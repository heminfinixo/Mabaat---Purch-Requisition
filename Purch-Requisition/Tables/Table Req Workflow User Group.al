table 50154 "Req Workflow User Group_IXO"

{
    DataClassification = ToBeClassified;
    Caption = 'Workflow User Group Ext';
    fields
    {
        field(90000; USERID; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = User."User Name";

        }
        field(90001; "Workflow User Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Workflow User Group";
        }
        field(90002; "Enable"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(90003; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(90004; "Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Material Requisition","Purchase Requisition";
        }

    }

    keys
    {
        key(PK; USERID, "Line No.")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}