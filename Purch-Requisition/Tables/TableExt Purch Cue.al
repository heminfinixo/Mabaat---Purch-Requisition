tableextension 50153 "Purch Cue_IXO" extends "Purchase Cue"
{
    fields
    {
        field(90000; "Requistions Approvals_IXO"; Integer)
        {
            // DataClassification = CustomerContent;
            FieldClass = FlowField;
            CalcFormula = count("Req. Approval Entries_IXO" where(Status = filter(Open), "Approver ID" = field("User ID Filter")));
        }
        // Add changes to table fields here
    }

    var

}