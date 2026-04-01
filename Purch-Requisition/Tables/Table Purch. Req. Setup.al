table 50151 "Purch. Req. Setup_IXO"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(90000; "Primary Key_IXO"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        field(90001; "Purchase Requisition Nos._IXO"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(90002; "Issue Material Batch_IXO"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = const('Item'));

        }
        field(90003; "Post While Issue Material_IXO"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(90004; "Location Validation_IXO"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        field(90005; "Material Requisition Nos._IXO"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(90006; "Email Notification Required"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        field(90007; "Material Req. G/L Account Cr."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(90008; "Material Req. G/L Account Dr."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        // field(90009; "Material G/L Account Dr.2"; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     TableRelation = "G/L Account";
        // }
        // field(90010; "Material G/L Account Dr.3"; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     TableRelation = "G/L Account";
        // }
        field(90011; "Material Request Gen. Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
        }
        field(90012; "Material Request Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Material Request Gen. Template"));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key_IXO")
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