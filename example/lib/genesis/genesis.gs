    -- This is a comment on .gs files. You can use it to write some notes about the file or the project
    -- And this are the things that can be counterintuitive:
    -- `F`: Folder
    -- `D`: File
    -- `-`: Property (Is important to add a space after the hyphen)
    -- `!`: This file will be skipped by the analyzer
    -- `?`: This property is not nullable on database and code
    -- `*`: Is complete necessary to add this symbol to identify the generation files folders
    -- `/DefaultValue`: This property will have a default value
    -- `full`: This file will be a StateFullWidget
    -- `less`: This file will be a StateLessWidget
    -- `cubit`: This file will be a Cubit
    -- You can delete this comment. If you want to know more about the structure, go to genesis_README.md
    -- Now, I propose a basic clean code structure for you to start working
    -- This is the structure of the project:

    Domain F
    __Database F
    ___Models F *
    ____Model1 D
    _____- Property1 int
    _____- Property2 string
    _____- Property3 bool
    _____- Property4 DateTime
    ____Model2 D
    _____- Property1 int
    _____- Property2 string
    _____- Property3 bool
    _____- Property4 DateTime
    ____Model3 D
    _____- Property1 int
    _____- Property2 string
    _____- Property3 double
    _____- Property4 DateTime
    ____Parameters D

    ___Preferences F *

    Repository F
    __Database F
    ___Entity F *
    -- The same as Domain.Database.Models but designed to be used by the repository
    -- If want some more entities, add them below
    ____Entity1 D
    _____- Property1 int
    _____- Property2 string
    _____- Property3 bool
    _____- Property4 DateTime
    _____- Property5 double

    Presentation F
    __Screens F *
    ___HomeScreen D full
    ___LoginScreen D less
    __Widgets F *
    __Blocks F *
    ___ApiBloc D
    ___RouterBloc D cubit
    