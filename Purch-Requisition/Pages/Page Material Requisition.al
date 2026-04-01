#pragma implicitwith disable
page 50165 "Material Requisition_IXO"
{
    PageType = List;
    ApplicationArea = All;
    Editable = false;
    UsageCategory = Lists;
    Caption = 'Material Requisition List';
    SourceTable = "Purchase Req. Header_IXO";
    SourceTableView = where("Document Type" = filter(Material), Status = filter(Open | "Pending Approval" | Rejected));
    CardPageId = "Material Requisition Card_IXO";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; REC."Document No.") //KV ADD REC
                {
                    ApplicationArea = All;
                }
                field("Service Request No."; Rec."Service Request No.")
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                /*  field("Vendor No."; "Vendor No.")
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
                ApplicationArea = all;
                Visible = false;
                //Visible = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    WorkflowMtrReq: Codeunit "Workflow Material Requisition";
                    PurReqHeader: Record "Purchase Req. Header_IXO";
                begin
                    PurReqHeader := Rec;
                    WorkflowMtrReq.OnClickSendApprovalRequestForAMaterialRequisitionDoc(PurReqHeader.RecordId);
                    Message(ApprovalRequestGeneratedMsg);
                end;

            }
            action("Cancel Approval Request")
            {

                ApplicationArea = All;
                Visible = false;
                //Visible = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var

                    WorkflowMtrReq: Codeunit "Workflow Material Requisition";
                    PurReqHeader: Record "Purchase Req. Header_IXO";

                begin
                    PurReqHeader := Rec;
                    WorkflowMtrReq.OnClickCancelApprovalRequestForAMaterialRequisitionDoc(PurReqHeader.RecordId);
                    Message(ApprovalReqCanceledForSelectedLinesMsg);
                end;

            }

        }
    }

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
