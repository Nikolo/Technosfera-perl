#include <EXTERN.h>
#include <perl.h>
#include <stdio.h>

static PerlInterpreter *my_perl;

/* "Real programmers can write assembly code in any language." */

void error_tmpl(char *message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
}

static void
print_var(char *var_name, char *var)
{
    HV *h_var;
    h_var = get_hv(var_name, 0);
    if(!h_var) error_tmpl("Vars hash not exist");
    SV **sr_var = hv_fetch(h_var, var, (int)strlen(var), 0);
    if(!sr_var){ error_tmpl("Var not exist");};
    if(SvTYPE(*sr_var) == SVt_IV || SvTYPE(*sr_var) == SVt_PVIV){ printf( "%li", SvIV(*sr_var)); }
    else if(SvTYPE(*sr_var) == SVt_NV || SvTYPE(*sr_var) == SVt_PVNV){ printf("%f", SvNV(*sr_var)); }
    else if(SvTYPE(*sr_var) == SVt_PV){ printf("%s", SvPV_nolen(*sr_var)); }
    else { error_tmpl("Incompatible type of var"); }
}

static void
call_func(char *func_name, int argv, char **argc )
{
    int count, f;
    dSP;                            /* initialize stack pointer         */
    ENTER;                          /* everything created after here    */
    SAVETMPS;                       /* ...is a temporary variable.      */
    PUSHMARK(SP);                   /* remember the stack pointer       */
    for(f=0;f<argv; f++ ){          /* push args onto the stack         */
        XPUSHs(sv_2mortal(newSVpv(argc[f], strlen(argc[f]))));
    }
    PUTBACK;                        /* make local stack pointer global  */
    count = call_pv(func_name, G_SCALAR|G_EVAL); /* call the function   */
    SPAGAIN;                        /* refresh stack pointer            */
    PUTBACK;
    if (SvTRUE(ERRSV)){             /* check on die                     */
        error_tmpl(SvPV_nolen(ERRSV));
    }
    else{
        if (count != 1)             /* check count var in stack         */
            error_tmpl("Perl callback must return 1 parameter");
        printf ("%s", POPp);        /* pop the return value from stack  */
    }
    FREETMPS;                       /* free that return value           */
    LEAVE;                          /* ...and the XPUSHed "mortal" args */
}

int main (int argc, char **argv, char **env)
{
    char *include_dir, *module;
    FILE *template;
    char *str, *buf, *found, *p_func, *arg_begin, *arg_end, tmp, *func_name, **args, *pkg_name, *var_name;
    int in_tag = 0, cur_param = 0, f, exitstatus = 0;
    const char *begin_tag = "<!--[", *end_tag = "]-->";
    const int max_params = 10, chunk_size = 1024;

    include_dir = malloc(sizeof(char)*strlen(argv[3])+3);
    module = malloc(sizeof(char)*strlen(argv[1])+3);
    strcpy(include_dir, "-I");
    strcat(include_dir, argv[3]);
    strcpy(module, "-M");
    strcat(module, argv[1]);

    char *perl_argv[] = { "", module, include_dir, "-e0" };

    pkg_name = malloc(sizeof(char)*strlen(argv[1]));
    strncpy(pkg_name, argv[1], strlen(argv[1]));
    strcat(pkg_name, "::");
    args = malloc(sizeof(int)*max_params);
    
    PERL_SYS_INIT3(&argc,&argv,&env);
    my_perl = perl_alloc();
    perl_construct( my_perl );
    exitstatus = perl_parse(my_perl, NULL, 4, perl_argv, (char **)NULL);
    if(exitstatus){
        exit(exitstatus);
    }
    exitstatus = perl_run(my_perl);

    template = fopen(argv[2], "r");
    if(template == NULL){ error_tmpl("Error open template"); }
    str = malloc(sizeof(char) * chunk_size);
    buf = str;
    while(strlen(str) || !feof(template)){
        if(!feof(template)) fread(buf, sizeof(char), chunk_size-strlen(str), template);
        found = 0;
        if(in_tag){
            found = strstr(str, end_tag);
        }
        else {
            found = strstr(str, begin_tag);
        }
        if( found != NULL ){
            if(in_tag){
                in_tag = 0;
                *found = '\0';
                p_func = strchr(str, '(');
                if(p_func != NULL){
                    cur_param = 0;
                    func_name = malloc(sizeof(char)*(p_func-str+strlen(pkg_name)+1));
                    *p_func = '\0';
                    strcpy(func_name, pkg_name);
                    strcat(func_name, str);
                    func_name[(p_func-str)+strlen(pkg_name)] = '\0';
                    arg_begin = p_func+1;
                    arg_end = arg_begin;
                    while( strlen(arg_begin) && ((arg_end = strchr(arg_begin, ',')) || (arg_end = strchr(arg_begin, ')')))){
                        if(*arg_end == ')' && arg_end == arg_begin && cur_param) error_tmpl("Error parse func");
                        if(*arg_end != ')' && *(arg_end+1) == '\0') error_tmpl("Error parse func");
                        if(cur_param > max_params) error_tmpl("To many params");
                        if(arg_end != arg_begin){
                            args[cur_param] = malloc(sizeof(char)*(arg_end-arg_begin+1));
                            strncpy(args[cur_param], arg_begin, arg_end-arg_begin);
                            args[cur_param][arg_end-arg_begin] = '\0';
                            cur_param++;
                        }
                        if(*arg_end == ')') {
                            call_func(func_name, cur_param, args);
                        }
                        arg_begin=arg_end+1;
                    }
                    if(strlen(arg_begin) != 0){ error_tmpl("Error parse func"); }
                    for(f=0; f<cur_param; f++){
                        free(args[f]);
                    }
                    free(func_name);
                }
                else{
                    var_name = malloc(sizeof(char)*(strlen("vars")+strlen(pkg_name)+1));
                    strcpy(var_name, pkg_name);
                    strcat(var_name, "vars");
                    var_name[strlen("vars")+strlen(pkg_name)] = '\0';
                    print_var(var_name, str);
                }
                memmove(str, found+strlen(end_tag), strlen(found+1)-strlen(end_tag)+2);
            }
            else {
                in_tag = 1;
                *found = '\0';
                printf( "%s", str );
                memmove(str, found+strlen(begin_tag), strlen(found+1)-strlen(begin_tag)+2);
            }
        }
        else {
            if(in_tag){
                error_tmpl("Error parse tag");
            }
            else{
                if(strlen(str) > strlen(begin_tag)){
                    tmp = str[strlen(str) - strlen(begin_tag)];
                    str[strlen(str) - strlen(begin_tag)] = '\0';
                    printf( "%s", str );
                    str[strlen(str) - strlen(begin_tag)] = tmp;
                    memmove(str, str + strlen(str)-strlen(begin_tag), strlen(str)-strlen(begin_tag)+1);
                }
                else {
                    printf("%s", str);
                    *str = '\0';
                }
            }
        }
        buf = str + strlen(str);
    }
    if(in_tag){
        error_tmpl("Unclosed tag");
    }
    else{
        printf( "%s", str);
    }
    free(pkg_name);
    free(args);
    perl_destruct(my_perl);
    perl_free(my_perl);
}
