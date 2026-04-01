tableextension 50151 "Purch. Line Ext._IXO" extends "Purchase Line"
{
    fields
    {
        field(90000; "Req. Document No._IXO"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Document No.';
        }
        field(90001; "Purch. Req. Line No._IXO"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Requistion Line No.';
        }
    }
}

