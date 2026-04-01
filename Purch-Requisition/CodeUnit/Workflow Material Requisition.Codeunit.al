codeunit 50154 "Workflow Material Requisition"
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
        WorkflowEventHandlingCust: Codeunit "Workflow Material Requisition";
        MaterialRequisitionSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Material Requisition document is requested';
        MaterialRequisitionCancelForApprovalEventDescTxt: TextConst ENU = 'Approval of a Material Requisition document is canceled';
        NoWorkflowEnabledErr: TextConst ENU = 'No approval workflow for this record type is enabled.';

        MaterialRequisitionWorkflowCategoryTxt: TextConst ENU = 'CDW';

        MaterialRequisitionWorkflowCategoryDescTxt: TextConst ENU = 'Claim Document';

        MaterialRequisitionApprovalWorkflowCodeTxt: TextConst ENU = 'CAPW';
        MaterialRequisitionApprovalWorkfowDescTxt: TextConst ENU = 'Claim Approval Workflow';
        PendingApprovalRequestExistsErr: TextConst ENU = 'An approval request already exists.';

    [IntegrationEvent(false, false)]
    procedure OnSendMaterialRequisitionForApproval(var MtrReq: Record "Purchase Req. Header_IXO")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMaterialRequisitionForApproval(var MtrReq: Record "Purchase Req. Header_IXO")
    begin

    end;

    procedure RunWorkflowOnSendMaterialRequisitionApprovalCode(): code[128];
    begin
        exit(UpperCase('RunWorkflowOnSendMaterialRequisitionApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Material Requisition", 'OnSendMaterialRequisitionForApproval', '', true, true)]
    local procedure RunWorkflowOnSendMaterialRequisitionApproval(var MtrReq: Record "Purchase Req. Header_IXO")
    begin
        WorkflowMgmt.HandleEvent(RunWorkflowOnSendMaterialRequisitionApprovalCode(), MtrReq);
    end;

    procedure RunWorkflowOnCancelMaterialRequisitionApprovalCode(): code[128];
    begin
        exit(UpperCase('RunWorkflowOnCancelMaterialRequisitionApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Material Requisition", 'OnCancelMaterialRequisitionForApproval', '', true, true)]
    local procedure RunWorkflowOnCancelMaterialRequisitionApproval(var MtrReq: Record "Purchase Req. Header_IXO")
    begin
        WorkflowMgmt.HandleEvent(RunWorkflowOnCancelMaterialRequisitionApprovalCode(), MtrReq);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMaterialRequisitionApprovalCode(), Database::"Purchase Req. Header_IXO", MaterialRequisitionSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMaterialRequisitionApprovalCode(), Database::"Purchase Req. Header_IXO", MaterialRequisitionCancelForApprovalEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelMaterialRequisitionApprovalCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMaterialRequisitionApprovalCode(), RunWorkflowOnSendMaterialRequisitionApprovalCode());
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendMaterialRequisitionApprovalCode());
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure AddCustomResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkFlowResponse: Codeunit "Workflow Response Handling";
    begin
        Case ResponseFunctionName of
            WorkFlowResponse.SetStatusToPendingApprovalCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.SetStatusToPendingApprovalCode(), RunWorkflowOnSendMaterialRequisitionApprovalCode());
            WorkFlowResponse.SendApprovalRequestForApprovalCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.SendApprovalRequestForApprovalCode(), RunWorkflowOnSendMaterialRequisitionApprovalCode());
            WorkFlowResponse.CancelAllApprovalRequestsCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.CancelAllApprovalRequestsCode(), RunWorkflowOnCancelMaterialRequisitionApprovalCode());
            WorkFlowResponse.OpenDocumentCode():
                WorkFlowResponse.AddResponsePredecessor(WorkFlowResponse.OpenDocumentCode(), RunWorkflowOnCancelMaterialRequisitionApprovalCode());
        end;
    end;





    procedure CheckMaterialRequisitionDocApprovalWorkflowEnable(var MtrReq: Record "Purchase Req. Header_IXO"): Boolean
    begin
        if not IsMaterialRequisitionDocApprovalWorkflowEnable(MtrReq) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsMaterialRequisitionDocApprovalWorkflowEnable(var MtrReq: Record "Purchase Req. Header_IXO"): Boolean
    begin
        if MtrReq.Status <> MtrReq.Status::Open then
            exit(false);
        exit(WorkflowMgmt.CanExecuteWorkflow(MtrReq, RunWorkflowOnSendMaterialRequisitionApprovalCode()));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        MtrReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(MtrReq);
                    ApprovalEntryArgument."Document Type" := MtrReq."Document Type";
                    ApprovalEntryArgument."Document No." := MtrReq."Document No.";
                end;
        end;
    end;

    procedure OnClickSendApprovalRequestForAMaterialRequisitionDoc(RecordID_P: RecordId)
    var
        MtrReq: Record "Purchase Req. Header_IXO";
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        MtrReq.GET(RecordID_P);
        MtrReq.CalcFields("Total Amount");
        //CheckMandatoryFieldsOnDocument(SRLine);
        IF ApprovalsMgmt.HasOpenApprovalEntries(RecordID_P) then
            ERROR(PendingApprovalRequestExistsErr);
        IF CheckMaterialRequisitionDocApprovalWorkflowEnable(MtrReq) then begin
            OnSendMaterialRequisitionForApproval(MtrReq);
            //MtrReq.Status := MtrReq.Status::"Pending Approval";
            //MtrReq.Modify();
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Record ID to Approve", RecordID_P);
            if ApprovalEntry.FindSet(true) then begin
                repeat
                    //if ApprovalEntry."Approver ID" <> UserId then begin
                    ApprovalEntry.Validate(Amount, MtrReq."Total Amount");
                    ApprovalEntry.Validate("Amount (LCY)", MtrReq."Total Amount");
                    ApprovalEntry.Modify(true);
                until ApprovalEntry.Next() = 0;
            end;

        end;
    end;

    procedure OnClickCancelApprovalRequestForAMaterialRequisitionDoc(RecordID_P: RecordId)
    var
        MtrReq: Record "Purchase Req. Header_IXO";
        ApprovalEntry: Record "Approval Entry";
        ApprovalEntry2: Record "Approval Entry";
    begin
        MtrReq.GET(RecordID_P);
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
                    MtrReq.Status := MtrReq.Status::Open;
                    MtrReq.Modify(true);
                until ApprovalEntry.Next() = 0;
            end;
            //ApprovalEntry.Reset();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MtrReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(MtrReq);
                    MtrReq.Status := MtrReq.Status::Open;
                    //MtrReq.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MtrReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(MtrReq);
                    MtrReq.Status := MtrReq.Status::Approved;
                    //MtrReq.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        MtrReq: Record "Purchase Req. Header_IXO";
    begin
        case RecRef.Number of
            database::"Purchase Req. Header_IXO":
                begin
                    RecRef.SetTable(MtrReq);
                    MtrReq.Status := MtrReq.Status::"Pending Approval";
                    // MtrReq.Modify(false);
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', True, True)]
    //local procedure UpdateMaterialRequisitionApprovalStatusRejected(var ApprovalEntry: Record "Approval Entry")
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        MtrReq: Record "Purchase Req. Header_IXO";
        RecRef: RecordRef;
    begin
        IF ApprovalEntry."Table ID" = 50152 then begin
            RecRef.Get(ApprovalEntry."Record ID to Approve");
            RecRef.SetTable(MtrReq);
            MtrReq.Status := MtrReq.Status::Rejected;
            MtrReq.Modify(true);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(MaterialRequisitionWorkflowCategoryTxt, MaterialRequisitionWorkflowCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record 454;
    begin
        WorkflowSetup.InsertTableRelation(Database::"Purchase Req. Header_IXO", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

}