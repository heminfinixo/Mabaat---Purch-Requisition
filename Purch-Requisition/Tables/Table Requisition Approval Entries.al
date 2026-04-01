table 50155 "Req. Approval Entries_IXO"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(90000; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;

        }
        field(90001; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(90002; "Document Type"; Enum "Purch. Req. Doc Type")
        {
            DataClassification = CustomerContent;
            //OptionMembers = "Material","Purchase";
        }
        field(90003; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(90004; "Salespers./Purch. Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(90005; "Sequence No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(90006; "Sender ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(90007; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(90008; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(90009; "Approver ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(90010; "Workflow Step Instance ID"; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(90011; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Created","Open","Canceled","Rejected","Approved";
        }

        field(90012; "Date-Time Sent for Approval"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(90013; "Last Date-Time Modified"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(90014; "Last Modified By User ID"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(90015; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(90016; "Available Credit Limit (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(90017; "Record ID to Approve"; RecordId)
        {
            DataClassification = CustomerContent;
        }
        field(90018; "Approval Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(90019; "User ID Filter"; Code[50])
        {
            // DataClassification = CustomerContent;
            FieldClass = FlowFilter;
        }
        field(90020; Remarks; Text[50])
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    var
        ReqApprovalEntry: Record "Req. Approval Entries_IXO";
    begin
        if ReqApprovalEntry.FindLast() then
            "Entry No." := ReqApprovalEntry."Entry No." + 1
        else
            "Entry No." := 1;
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