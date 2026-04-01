codeunit 50153 "Workflow Purchase Requisition"
{
    Permissions = tabledata "Approval Entry" = RIMD,
    tabledata "Approval Comment Line" = RIMD,
    tabledata "Purchase Req. Header_IXO" = RIMD,
    tabledata "Purchase Requisition Line_IXO" = RIMD,
    tabledata "User Setup" = RM,
    tabledata "Workflow Response" = R,
    tabledata "Workflow Step Instance" = RIMD,
    tabledata "Workflow Event" = RM,
    tabledata "Workflow Step Argument" = R;
    trigger OnRun()
    begin

    end;

    var
        WorkflowMgmt: Codeunit 1501;
        WorkflowEventHandling: Codeunit 1520;
        WorkflowSetup: Codeunit 1502;
        WorkflowEventHandlingCust: Codeunit "Workflow Purchase Requisition";
        PurchaseRequisitionSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Purchase Requisition document is requested';
        PurchaseRequisitionCancelForApprovalEventDescTxt: TextConst ENU = 'Approval of a Purchase Requisition document is canceled';
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.';

        PurchaseRequisitionWorkflowCategoryTxt: TextConst ENU = 'CDW';

        PurchaseRequisitionWorkflowCategoryDescTxt: TextConst ENU = 'Claim Document';

        PurchaseRequisitionApprovalWorkflowCodeTxt: TextConst ENU = 'CAPW';
        PurchaseRequisitionApprovalWorkfowDescTxt: TextConst ENU = 'Claim Approval Workflow';
        PendingApprovalRequestExistsErr: TextConst ENU = 'An approval request already exists.';

    [IntegrationEvent(false, false)]
    procedure OnSendPurchaseRequisitionForApproval(var PurReq: Record "Purchase Req. Header_IXO")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchaseRequisitionForApproval(var PurReq: Record "Purchase Req. Header_IXO")
    begin

    end;

    procedure RunWorkflowOnSendPurchaseRequisitionApprovalCode(): code[128];
    begin
        exit(UpperCase('RunWorkflowOnSendPurchaseRequisitionApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Purchase Requisition", 'OnSendPurchaseRequisitionForApproval', '', true, true)]
    local procedure RunWorkflowOnSendPurchaseRequisitionApproval(var PurReq: Record "Purchase Req. Header_IXO")
    begin
        WorkflowMgmt.HandleEvent(RunWorkflowOnSendPurchaseRequisitionApprovalCode(), PurReq);
    end;

    procedure RunWorkflowOnCancelPurchaseRequisitionApprovalCode(): code[128];
    begin
        exit(UpperCase('RunWorkflowOnCancelPurchaseRequisitionApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Purchase Requisition", 'OnCancelPurchaseRequisitionForApproval', '', true, true)]
    local procedure RunWorkflowOnCancelPurchaseRequisitionApproval(var PurReq: Record "Purchase Req. Header_IXO")
    begin
        WorkflowMgmt.HandleEvent(RunWorkflowOnCancelPurchaseRequisitionApprovalCode(), PurReq);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPurchaseRequisitionApprovalCode(), Database::"Purchase Req. Header_IXO", PurchaseRequisitionSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPurchaseRequisitionApprovalCode(), Database::"Purchase Req. Header_IXO", PurchaseRequisitionCancelForApprovalEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelPurchaseRequisitionApprovalCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPurchaseRequisitionApprovalCode(), RunWorkflowOnSendPurchaseRequisitionApprovalCode());
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendPurchaseRequisitionApprovalCode());
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure AddCustomResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkFlowResponse: Codeunit "Workflow Response Handling";
    begin
        Case ResponseFunctionName of
            WorkFlowResponse.SetStatusToPendingApprovalCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.SetStatusToPendingApprovalCode(), RunWorkflowOnSendPurchaseRequisitionApprovalCode());
            WorkFlowResponse.SendApprovalRequestForApprovalCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendPurchaseRequisitionApprovalCode());
            WorkFlowResponse.CancelAllApprovalRequestsCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelPurchaseRequisitionApprovalCode());
            WorkFlowResponse.OpenDocumentCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.OpenDocumentCode(), RunWorkflowOnCancelPurchaseRequisitionApprovalCode());
        end;
    end;





    procedure CheckPurchaseRequisitionDocApprovalWorkflowEnable(var PurReq: Record "Purchase Req. Header_IXO"): Boolean
    begin
        if not IsPurchaseRequisitionDocApprovalWorkflowEnable(PurReq) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsPurchaseRequisitionDocApprovalWorkflowEnable(var PurReq: Record "Purchase Req. Header_IXO"): Boolean
    begin
        if PurReq.Status <> PurReq.Status::Open then
            exit(false);
        exit(WorkflowMgmt.CanExecuteWorkflow(PurReq, RunWorkflowOnSendPurchaseRequisitionApprovalCode()));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PurReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(PurReq);
                    ApprovalEntryArgument."Document Type" := PurReq."Document Type";
                    ApprovalEntryArgument."Document No." := PurReq."Document No.";
                end;
        end;
    end;

    procedure OnClickSendApprovalRequestForAPurchaseRequisitionDoc(RecordID_P: RecordId)
    var
        PurReq: Record "Purchase Req. Header_IXO";
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        PurReq.GET(RecordID_P);
        PurReq.CalcFields("Total Amount");
        //CheckMandatoryFieldsOnDocument(SRLine);
        IF ApprovalsMgmt.HasOpenApprovalEntries(RecordID_P) then
            ERROR(PendingApprovalRequestExistsErr);
        IF CheckPurchaseRequisitionDocApprovalWorkflowEnable(PurReq) then begin
            OnSendPurchaseRequisitionForApproval(PurReq);
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecordID_P);
            if ApprovalEntry.FindSet(true) then begin
                repeat
                    //if ApprovalEntry."Approver ID" <> UserId then begin
                    ApprovalEntry.Validate(Amount, PurReq."Total Amount");
                    ApprovalEntry.Validate("Amount (LCY)", PurReq."Total Amount");
                    ApprovalEntry.Modify(true);
                until ApprovalEntry.Next() = 0;
            end;

        end;
    end;

    procedure OnClickCancelApprovalRequestForAPurchaseRequisitionDoc(RecordID_P: RecordId)
    var
        PurReq: Record "Purchase Req. Header_IXO";
        ApprovalEntry: Record "Approval Entry";
        ApprovalEntry2: Record "Approval Entry";
    begin
        PurReq.GET(RecordID_P);
        ApprovalEntry.SetRange("Record ID to Approve", RecordID_P);
        if ApprovalEntry.FindFirst() then begin
            if ApprovalEntry."Approver ID" <> UserId then
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
            ApprovalEntry.Modify(true);

            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecordID_P);
            if ApprovalEntry.FindSet(true) then begin
                repeat
                    ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                    ApprovalEntry.Modify(true);
                    PurReq.Status := PurReq.Status::Open;
                    PurReq.Modify(true);
                until ApprovalEntry.Next() = 0;
            end;
            //ApprovalEntry.Reset();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PurReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(PurReq);
                    PurReq.Status := PurReq.Status::Open;
                    PurReq.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PurReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(PurReq);
                    PurReq.Status := PurReq.Status::Approved;
                    PurReq.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PurReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(PurReq);
                    PurReq.Status := PurReq.Status::"Pending Approval";
                    PurReq.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', True, True)]
    local procedure UpdatePurchaseRequisitionApprovalStatusRejected(var ApprovalEntry: Record "Approval Entry")
    var
        PurReq: Record "Purchase Req. Header_IXO";
        RecRef: RecordRef;
    begin
        IF ApprovalEntry."Table ID" = 50152 then begin
            RecRef.Get(ApprovalEntry."Record ID to Approve");
            RecRef.SetTable(PurReq);
            PurReq.Status := PurReq.Status::Rejected;
            PurReq.Modify();
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(PurchaseRequisitionWorkflowCategoryTxt, PurchaseRequisitionWorkflowCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record 454;
    begin
        WorkflowSetup.InsertTableRelation(Database::"Purchase Req. Header_IXO", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

}