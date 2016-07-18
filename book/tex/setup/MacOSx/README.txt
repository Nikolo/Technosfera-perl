Необходимый софт:

Компиляция:

- TeX Live 2015 или mactex-2016, второй можно скачать тут: http://www.tug.org/texlive/ или https://cloud.mail.ru/public/JSvX/DPmxWeGRi
- python + pip https://pip.pypa.io/en/stable/installing/ (https://bootstrap.pypa.io/get-pip.py)
- Pygments (pip install Pygments)

Pедактирование: 

- TeXStudio (http://www.texstudio.org/) или https://cloud.mail.ru/public/J1aU/LG8obEbmN
- Любой удобный для вас редактор

Если использовать софт из облака - то после установки надо наложить патч и заменить один из файлов целиком.

cp setup/fontspec.lua /usr/local/texlive/2016/texmf-dist/tex/latex/fontspec/fontspec.lua
patch -p0 setup/fontspec-lua.dtx.patch /usr/local/texlive/2016/texmf-dist/source/latex/fontspec/fontspec-lua.dtx

Если качать с официального сайта, то кол-во проблем и надобность наложения патчев может быть отличной от написанного выше.

Процесс построения документа (описание для TexStudio):

 - Для построения документа необходимо использовать компилятор Lualatex. Для этого нужно проследовать по пути: Параметры ->Конфигурация TexStudio -> Построение и выбрать в качестве компилятора по умолчанию Lualatex
- В графе Параметры -> Конфигурация TexStudio -> Команды  в строчке Lualatex указать путь до компилятора (флаги обязательны). Пример: "C:/texlive/2015/bin/win32/lualatex.exe" -synctex=1 -shell-escape -output-directory=folder_name -interaction=nonstopmode %.tex. 
- По умолчанию сборка производится в подпапку с именем build (-output-directory=build). В архиве ее нет, перед компиляцией необходимо создать. После компиляции там будет лежать pdf файл. Так же нужно создать папки build/lectures и 12 папок с номерами лекций build/lectures/L[1..12]
- Если требуется провести построение в корневой директории, необходимо убрать флаг -output-directory=build во вкладке Параметры -> Конфигурация TexStudio -> Команды  в строчке Lualatex, а также в файле main.tex после команды \usepackage[outputdir=build]{minted}

Процесс построения из командной строки:

make build

