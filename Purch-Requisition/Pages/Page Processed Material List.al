#pragma implicitwith disable
page 50166 "Processed Material List_IXO"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Processed Material';
    UsageCategory = Lists;
    Editable = false;
    //InsertAllowed = false;
    DeleteAllowed = false;           //kv
    SourceTable = "Purchase Req. Header_IXO";
    SourceTableView = WHERE(Status = filter(Processed | Approved), "Document Type" = const(Material));
    CardPageId = "Material Requisition Card_IXO";
    layout
    {
        area(Content)
        {
            repeater("Processed Documents List")
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                /*   field("Vendor No."; "Vendor No.")
                  {
                      ApplicationArea = All;
                  }
                  field("Vendor Name"; "Vendor Name")
                  {
                      ApplicationArea = All;
                  } */
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Created By User"; Rec."Created By User")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(Print)
            {
                ApplicationArea = All;
                Image = Print;
                //RunObject = report "Purchase Requisition IXO";
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    PR_lRep: Report "Purchase Requisition IXO";
                begin
                    PR_lRep.SetParameter(Rec."Document No.");
                    PR_lRep.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var

    begin
        Rec.SetFilter("Created By User", UserId());

    end;


    var

}
#pragma implicitwith restore
