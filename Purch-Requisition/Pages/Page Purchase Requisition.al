#pragma implicitwith disable
page 50152 "Purchase Requisition List_IXO"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'Purchase Requisition';
    SourceTable = "Purchase Req. Header_IXO";
    SourceTableView = where("Document Type" = filter(Purchase), Status = filter(Open | "Pending Approval" | Rejected));
    CardPageId = "Purchase Requisition Card_IXO";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }

                field(UserID; UserID())
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                //ApplicationArea = all;
                Visible = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    WorkflowPurReq: Codeunit "Workflow Purchase Requisition";
                    PurReqHeader: Record "Purchase Req. Header_IXO";
                begin
                    PurReqHeader := Rec;
                    WorkflowPurReq.OnClickSendApprovalRequestForAPurchaseRequisitionDoc(PurReqHeader.RecordId);
                    Message(ApprovalRequestGeneratedMsg);
                end;

            }
            action("Cancel Approval Request")
            {

                //ApplicationArea = All;
                Visible = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var

                    WorkflowPurReq: Codeunit "Workflow Purchase Requisition";
                    PurReqHeader: Record "Purchase Req. Header_IXO";

                begin
                    PurReqHeader := Rec;
                    WorkflowPurReq.OnClickCancelApprovalRequestForAPurchaseRequisitionDoc(PurReqHeader.RecordId);
                    Message(ApprovalReqCanceledForSelectedLinesMsg);
                end;

            }
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
        ApprovalMgmt: Codeunit 1535;
        WorkflowWebhookMgt: Codeunit 1543;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        CanRequestApprovalForFlow: Boolean;
        ApprovalReqCanceledForSelectedLinesMsg: TextConst ENU = 'The approval request for the selected record has been canceled.';
        ApprovalRequestGeneratedMsg: TextConst ENU = 'An approval request has been sent.';

    trigger OnAfterGetRecord()
    var

    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}
#pragma implicitwith restore
