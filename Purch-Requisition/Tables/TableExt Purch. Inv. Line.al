tableextension 50154 "Purch. Inv. Line_IXO" extends "Purch. Inv. Line"
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