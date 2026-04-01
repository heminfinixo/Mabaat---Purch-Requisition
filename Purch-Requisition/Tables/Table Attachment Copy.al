table 50150 "Attachment Copy_IXO"
{
    Caption = 'Attachment';

    fields
    {
        field(90000; "Doc No._IXO"; Code[20])
        {
            DataClassification = CustomerContent;


        }
        field(90001; "Attachment File_IXO"; BLOB)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment File';
        }
        field(90002; "Storage Type_IXO"; enum "Attachment Storage Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Storage Type';
            //OptionCaption = 'Embedded,Disk File,Exchange Storage';
            //OptionMembers = Embedded,"Disk File","Exchange Storage";
        }
        field(90003; "Storage Pointer_IXO"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'File Name';
        }
        field(90004; "File Extension_IXO"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'File Extension';
        }
        field(90005; "Read Only_IXO"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Read Only';
        }
        field(90006; "Last Date Modified_IXO"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Date Modified';
        }
        field(90007; "Last Time Modified_IXO"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Time Modified';
        }
        field(90008; "Merge Source_IXO"; BLOB)
        {
            DataClassification = CustomerContent;
            Caption = 'Merge Source';
        }
        field(90009; "Line No_IXO"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(90010; "Item No._IXO"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(90011; "No._IXO"; Integer)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PrimaryKey; "Doc No._IXO", "Line No_IXO")
        {
        }

    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Attachment2: Record "Attachment Copy_IXO";
        NextAttachmentNo: Integer;
    begin
        "Last Date Modified_IXO" := Today();
        "Last Time Modified_IXO" := Time();

        Attachment2.LockTable();
        if Attachment2.FindLast() then
            NextAttachmentNo := Attachment2."No._IXO" + 1
        else
            NextAttachmentNo := 1;

        //"No." := NextAttachmentNo;

        RMSetup.Get();
        "Storage Type_IXO" := RMSetup."Attachment Storage Type";
        if "Storage Type_IXO" = "Storage Type_IXO"::"Disk File" then begin
            RMSetup.TestField("Attachment Storage Location");
            "Storage Pointer_IXO" := RMSetup."Attachment Storage Location";
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified_IXO" := Today();
        "Last Time Modified_IXO" := Time();
    end;

    var

        RMSetup: Record "Marketing Setup";




}

