tableextension 50155 "Req. Wksh. Name Ext_IXO" extends 245
{
    fields
    {
        field(90000; "No.Series_IXO"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";

        }
        field(90001; "Posting No. Series_IXO"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(90002; "Requisition Type_IXO"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Purchase","Material";
        }
    }

    var

}


