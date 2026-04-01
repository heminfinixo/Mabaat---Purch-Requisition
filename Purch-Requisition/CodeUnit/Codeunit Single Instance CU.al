codeunit 50152 "Single Instance IXO"
{
    SingleInstance = true;
    trigger OnRun()
    begin
    end;


    procedure FromApprovedPageTrue()

    begin
        MyBoolean := true;
        //exit(MyBoolean)
    end;

    procedure FromApprovedPagefalse()

    begin
        MyBoolean := false;
        //exit(MyBoolean)
    end;

    procedure ReturnMyBool(): Boolean

    begin
        exit(MyBoolean);
    end;


    var
        MyBoolean: Boolean;



}