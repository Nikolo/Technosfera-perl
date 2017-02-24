{
    package A;

    sub test {
        return 42;
    }
}

if (A->can('test')) {
    print A->test;
}
