tableextension 50152 "Purch Cr. Memo_IXO" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(90000; "Req. Document No._IXO"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(90001; "Purch. Req. Line No._IXO"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }



}