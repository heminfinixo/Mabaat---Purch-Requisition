#pragma implicitwith disable
page 50155 "Purchase Requisition Card_SR"
{
    PageType = Document;
    // ApplicationArea = All;
    Caption = 'Purchase Requisition';
    //  UsageCategory = Administration;
    SourceTable = "Purchase Req. Header_IXO";
    RefreshOnActivate = true;
    //SourceTableView = where("Document Type" = filter(Purchase));

    //BN



    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    AssistEdit = true;
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    var

                    begin
                        Rec.AssistEdit()

                    end;
                }
                /* field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
 */

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Required Date';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                }
                field(Subject; Rec.Subject)
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
                field(UserID; Rec."Created By User")
                {
                    ApplicationArea = All;
                }


            }
            part(Lines; "Purchase Req. Subform_IXO")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Visible = true;
                ShowFilter = true;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = field("Document No."), "Document Type" = field("Document Type");

            }

        }

        area(FactBoxes)
        {
            part("Line's File Attachments"; "Line Attachment Factbox_IXO")
            {
                ApplicationArea = All;
                Provider = Lines;
                SubPageLink = "Item No._IXO" = field("No."), "Line No_IXO" = field("Line No."), "Doc No._IXO" = field("Document No.");
            }
            part(NewFactBox; "Item Invoicing FactBox")
            {
                ApplicationArea = All;
                Provider = Lines;
                SubPageLink = "No." = field("No.");
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
        area(Navigation)
        {
            //     action("Approve")
            //     {
            //         ApplicationArea = All;
            //         Image = Approve;
            //         Promoted = true;
            //         PromotedCategory = Process;
            //         Visible = ApproveBool;

            //         trigger OnAction()
            //         var
            //             Cont1: Record "Req. Approval Entries_IXO";
            //             Cont2: Record "Purchase Req. Header_IXO";
            //             WrkFlw: Record "Workflow User Group Member";
            //             ReqUser: Record "Req Workflow User Group_IXO";
            //             Seq: Integer;
            //             ApproverCodeCont: Code[20];


            //         begin
            //             Cont1.Reset();
            //             Cont1.SetCurrentKey("Sequence No.");
            //             Cont1.SetFilter("Document No.", Rec."Document No.");
            //             Cont1.SetRange("Document Type", Rec."Document Type");
            //             Cont1.SetFilter(Status, 'Open|Created');//Did this work.
            //             Cont1.SetAscending("Sequence No.", true);
            //             IF Cont1.FindSet() THEN begin
            //                 repeat
            //                     IF Cont1.Status = Cont1.Status::Open then begin

            //                         Cont1.Status := Cont1.Status::Approved;
            //                         Cont1.Modify();
            //                         Seq := Cont1."Sequence No.";
            //                     End;
            //                     IF (Cont1.Status = Cont1.Status::Created) AND (Cont1."Sequence No." = Seq + 1) then begin

            //                         Cont1.Status := Cont1.Status::Open;
            //                         Cont1.Modify();

            //                     end;

            //                 until Cont1.Next() = 0;

            //                 ReqUser.Reset();
            //                 ReqUser.SetFilter(USERID, UserId());
            //                 IF Rec."Document Type" = Rec."Document Type"::Material then
            //                     ReqUser.SetFilter("Transaction Type", 'Material Requisition');
            //                 IF Rec."Document Type" = Rec."Document Type"::Purchase then
            //                     ReqUser.SetFilter("Transaction Type", 'Purchase Requisition');

            //                 if ReqUser.FindFirst() then
            //                     ApproverCodeCont := ReqUser."Workflow User Group";


            //                 WrkFlw.Reset();
            //                 WrkFlw.SetCurrentKey("Sequence No.");
            //                 WrkFlw.SetRange(WrkFlw."Workflow User Group Code", ApproverCodeCont);
            //                 WrkFlw.SetAscending("Sequence No.", true);
            //                 IF WrkFlw.FindLast() then begin
            //                     IF WrkFlw."Sequence No." = Seq then
            //                         Cont2.Reset();
            //                     Cont2.SetFilter("Document No.", Rec."Document No.");
            //                     Cont2.SetRange("Document Type", Rec."Document Type");
            //                     IF Cont2.FindFirst() then begin
            //                         Cont2.Status := Cont2.Status::Approved;
            //                         Cont2.Modify();
            //                     end;
            //                 end;
            //             end;
            //         END;
            //     }

            //     action("Reject")
            //     {
            //         ApplicationArea = All;
            //         Image = Reject;
            //         Promoted = true;
            //         PromotedCategory = Process;
            //         Visible = RejectBool;

            //         trigger OnAction()
            //         var
            //             recPurchReqLine: Record "Purchase Req. Header_IXO";
            //         begin
            //             Rec.Status := Rec.Status::Rejected;
            //             Rec.Modify();
            //             recPurchReqLine.SetFilter("Document No.", Rec."Document No.");
            //             IF recPurchReqLine.FindFirst() then begin
            //                 recPurchReqLine.Status := recPurchReqLine.Status::Rejected;
            //                 recPurchReqLine.Modify();
            //             end;
            //         end;
            //     }
        }
        area(Processing)
        {

            action("Submit")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Enabled = SubmitBool;
                Caption = 'Submit';
                // Promoted = true;
                // PromotedCategory = Process;


                trigger OnAction()
                var
                    recLines: Record "Purchase Requisition Line_IXO";
                begin
                    IF NOT (Rec.Status = Rec.Status::Open) then
                        Error('Action not Allowed. Document Status must be Open.');

                    recLines.Reset();
                    recLines.SETRANGE("Document Type", Rec."Document Type");
                    recLines.SETRANGE("Document No.", Rec."Document No.");
                    recLines.SetFilter(Type, '<>%1', recLines.Type::" ");
                    recLines.SetRange(Quantity, 0);
                    IF recLines.FindFirst() then
                        ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.");


                    recLines.Reset();
                    recLines.SETRANGE("Document Type", Rec."Document Type");
                    recLines.SETRANGE("Document No.", Rec."Document No.");
                    if recLines.IsEmpty() then
                        ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.");



                    recLines.SETRANGE("Document Type", Rec."Document Type");
                    recLines.SETRANGE("Document No.", Rec."Document No.");
                    IF NOT recLines.FIND('-') THEN
                        ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.")


                    else
                        Rec.Status := Rec.Status::Approved;
                    Rec.Modify();
                    CurrPage.Update();
                    // SendInvoiceEmail(Rec."Document No.", 'mesamabbas@hotmail.com', "Document No.");


                end;
            }
            // action("Send Approval")
            // {
            //     ApplicationArea = All;
            //     Image = SendApprovalRequest;
            //     Enabled = SendApprBool;
            //     //  Promoted = true;
            //     // PromotedCategory = Process;

            //     trigger OnAction()
            //     var
            //         WrkFlw: Record "Workflow User Group Member";
            //         IXOWorkFlow: Record "Req Workflow User Group_IXO";
            //         User: Record User;
            //         UserGroupSys: Record "Workflow User Group Member";
            //         Setup: Record "Purch. Req. Setup_IXO";
            //         Cont3: Record "Purchase Req. Header_IXO";
            //         recLines: Record "Purchase Requisition Line_IXO";
            //         CodeUnitIcreated: Codeunit "Purchase Req. Mgmt._IXO";
            //         Cont: Code[20];
            //         Cont2: Code[50];
            //     begin
            //         Setup.Get();
            //         recLines.Reset();
            //         recLines.SETRANGE("Document Type", Rec."Document Type");
            //         recLines.SETRANGE("Document No.", Rec."Document No.");
            //         recLines.SetFilter(Type, '<>%1', recLines.Type::" ");
            //         recLines.SetRange(Quantity, 0);
            //         IF recLines.FindFirst() then
            //             ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.");
            //         recLines.Reset();
            //         recLines.SETRANGE("Document Type", Rec."Document Type");
            //         recLines.SETRANGE("Document No.", Rec."Document No.");
            //         if recLines.IsEmpty() then
            //             ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.");
            //         // else
            //         //   ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.");
            //         //  IF NOT recLines.FIND('-') THEN
            //         //  ERROR('There is nothing to release for the document of type %1 with the number %2.', Rec."Document Type", Rec."Document No.");
            //         //   IF recLines.Quantity = 0 then
            //         //    Error('Quantity must not be 0');
            //         // if recLines.Type = recLines

            //         UserContainer.SetRange(UserContainer.USERID, UserId());
            //         UserContainer.Find('-');
            //         if UserContainer."Workflow User Group" = '' then
            //             ERROR('Approval setup does not exists for this user. Identification fields are user %1 , workflow user group %2 in user setup.', UserId(), UserContainer."Workflow User Group");

            //         if (Rec.Status = Rec.Status::"Pending Approval") OR (Rec.Status = Rec.Status::Approved) then
            //             ERROR('This action is not allowed. Your document Status is %1.', Rec.Status);

            //         WrkFlw.SetFilter("Workflow User Group Code", UserContainer."Workflow User Group");
            //         IF WrkFlw.FindSet() THEN begin
            //             repeat
            //                 CodeUnitIcreated.CreateApprovalEntries(Rec."Document Type", Rec."Document No.", Rec."Purchaser Code", WrkFlw."Sequence No.", Rec."Total Amount", WrkFlw."User Name", rEC.RecordId(), WrkFlw."Workflow User Group Code");
            //             until WrkFlw.NEXT() = 0;
            //             Message('The Purchase Requisition Request has been sent for "Approval".');
            //             IXOWorkFlow.SetFilter(USERID, UserId());
            //             IF IXOWorkFlow.FindFirst() then
            //                 Cont := IXOWorkFlow."Workflow User Group";
            //             UserGroupSys.SetFilter("Workflow User Group Code", Cont);
            //             UserGroupSys.SetRange("Sequence No.", 1);
            //             IF UserGroupSys.FindFirst() then
            //                 Cont2 := UserGroupSys."User Name";
            //             User.SetFilter("User Name", Cont2);
            //             IF (User.FindFirst()) AND (Setup."Email Notification Required" = true) then
            //                 SendInvoiceEmail(User."Contact Email", Rec."Document No.");
            //             /*  User.SetFilter(Code, UserId);
            //              IF User.FindFirst() then begin
            //                  User2.SetFilter("User Name", User.Code);
            //                  recSendEmail.SendEmail(User2."Contact Email");
            //              end; */
            //             Cont3.SetFilter("Document No.", Rec."Document No.");
            //             Cont3.SetRange("Document Type", Rec."Document Type");
            //             IF Cont3.FindFirst() then
            //                 IF not (Cont3.Status = Cont3.Status::Approved) then
            //                     SetDocStatusToPending();

            //         END;


            //     end;
            // }
            // action("Cancel Approval")
            // {
            //     ApplicationArea = All;
            //     Image = CancelApprovalRequest;
            //     Enabled = CancelApprBool;
            //     //  Promoted = true;
            //     //  PromotedCategory = Process;

            //     trigger OnAction()
            //     var
            //     //  recHeader: Record "Purchase Req. Header_IXO";
            //     begin
            //         /*   recHeader.SetRange("Document Type", Rec."Document Type");
            //           recHeader.SetRange("Document No.", Rec."Document No.");
            //           if recHeader.FindFirst() then
            //           IF recHeader.Status = recHeader.Status::Open then */

            //         IF NOT (Rec.Status = Rec.Status::"Pending Approval") then
            //             Message('Status must not be %1', Rec.Status)
            //         else begin
            //             SetDocStatusToOpen();
            //             Message('The Purchase Requisition Request has been "Cancelled" Succesfully.');
            //         end;
            //     end;
            // }


            action("Copy Purchase Requisition")
            {
                ApplicationArea = All;
                Image = CopyDocument;
                ToolTip = 'Copy Existing Purchase Req. Document';
                Caption = 'Copy Purchase Requisition';
                //  Promoted = true;
                // PromotedCategory = Process;


                trigger OnAction()
                var

                    recCopyDocReqPage: page "Copy Purchase Req. Page_IXO";

                begin
                    IF NOT (Rec.Status = Rec.Status::Open) then
                        Message('Document Status must be Open to Copy Existing Document')
                    else
                        IF Rec."Document No." = '' then
                            Error('Document No. must not be Empty.')
                        else

                            IF recCopyDocReqPage.RunModal() = Action::OK THEN
                                recCopyDocReqPage.CopyMaterial(Rec."Document No.");


                    /*          if Page.RunModal(0, prrecheader) = Action::LookupOK then begin
                                 recCopyDocReqPage.CopyMaterial(Rec."Document No.");

                             end; */
                end;
            }
            /*   action("Copy Material Req. Document")
              {
                  ApplicationArea = All;
                  Image = CopyDocument;
                  Promoted = true;
                  PromotedCategory = Process;
                  PromotedIsBig = true;

                  trigger OnAction()
                  var
                      recCopyDocReqPage: page 90049;
                  begin
                      IF Rec."Document No." = '' then
                          Error('Document No. cannot be Null. Please generate a Document No before using Copy Document function');

                      recCopyDocReqPage.RunModal();
                      recCopyDocReqPage.CopyMaterial(Rec."Document No.");
                  end;
              } */
            action("Copy Purchase Order")
            {
                ApplicationArea = All;
                ToolTip = 'Copy Existing Purchase Order Document';
                Caption = 'Copy Purchase Order';
                Image = CopyDocument;
                // Promoted = true;
                //  PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                var
                    recCopyDocReqPage: page "Copy Purchase Order Page_IXO";
                begin
                    IF NOT (Rec.Status = Rec.Status::Open) then
                        Message('Document Status must be Open to Copy Existing Document')
                    else
                        IF Rec."Document No." = '' then
                            Error('Document No. Must not be Empty')
                        ELSE
                            IF recCopyDocReqPage.RunModal() = Action::OK THEN
                                recCopyDocReqPage.CopyMaterial(Rec."Document No.");
                end;
            }
            action("Approvals")
            {
                ApplicationArea = All;
                Image = Approvals;
                RunObject = page "Approval Entries for User_IXO";
                RunPageLink = "Document No." = field("Document No."), "Document Type" = field("Document Type");

                trigger OnAction()
                var

                begin



                END;
            }
        }
    }
    var
        ReqtoAppr: Record "Req. Approval Entries_IXO";
        UserContainer: Record "Req Workflow User Group_IXO";
        SubmitBool: Boolean;
        SendApprBool: Boolean;
        CancelApprBool: Boolean;

        ApproveBool: Boolean;
        RejectBool: Boolean;


    local procedure SendInvoiceEmail(ToAddress: Text; DocNoIn: Code[20]);
    var
        //SmtpMailSetup: record "SMTP Mail Setup";
        CompanyInformation: Record "Company Information";
        //SMTPMail: Codeunit "SMTP Mail";
        TenantMgmt: Codeunit "Environment Information";
        ListOfSender: List of [Text];
        EmailSubject: Text;



    begin
        CompanyInformation.Get();
        // SmtpMailSetup.get();
        ListOfSender.Add(ToAddress);
        EmailSubject := StrSubstNo(CompanyInformation.Name);

        //SMTPMail.CreateMessage(CompanyInformation.Name, SmtpMailSetup."User ID", ListOfSender, EmailSubject, CompanyName(), true);
        // SMTPMail.AppendBody('<h3>' + 'Hello,' + '<h3>');
        //SMTPMail.AppendBody('<br/>');
        //SMTPMail.AppendBody('<p>' + 'You have a Purchase Requisition with Document No.' + DocNoIn + ' for Approval Request' + '</p>');
        // if TenantMgmt.IsSandbox() then
        //     SMTPMail.AppendBody('<p>' + '<a href=' + 'https://www.businesscentral.dynamics.com/' + Database.TenantId() + '/sandbox/?page=' + format(Page::"Req. Approval Entries_IXO") + '> Please click here to go to Approvals </a> </p>')
        // else
        //     SMTPMail.AppendBody('<p>' + '<a href=' + 'https://www.businesscentral.dynamics.com/' + Database.TenantId() + '/?page=' + format(Page::"Req. Approval Entries_IXO") + '> Please click here to go to Approvals </a> </p>');

        // SMTPMail.Send();

    end;


    // procedure SetDocStatusToOpen()
    // var
    //     ApprovalEntries: Record "Req. Approval Entries_IXO";
    // begin
    //     Rec.Status := Rec.Status::Open;
    //     Rec.Modify();

    //     ApprovalEntries.SetFilter("Document No.", Rec."Document No.");
    //     ApprovalEntries.SetRange("Document Type", Rec."Document Type");
    //     ApprovalEntries.SetFilter(Status, '%1|%2', ApprovalEntries.Status::Created, ApprovalEntries.Status::Open);
    //     IF ApprovalEntries.FindSet() THEN
    //         repeat
    //             ApprovalEntries.Status := ApprovalEntries.Status::Canceled;
    //             ApprovalEntries.Modify();
    //         until ApprovalEntries.Next() = 0;

    // end;

    // procedure SetDocStatusToPending()
    // var
    // begin
    //     Rec.Status := Rec.Status::"Pending Approval";
    //     Rec.Modify();
    // end;

    // procedure SetDocStatusToApproved()
    // var
    // begin
    //     Rec.Status := Rec.Status::Approved;
    //     Rec.Modify();
    // end;

    // trigger OnOpenPage()
    // var
    //     recWorkflow: Record "Req Workflow User Group_IXO";

    // begin


    //     recWorkflow.SetRange(USERID, UserId());
    //     recWorkflow.SetFilter("Transaction Type", 'Purchase Requisition');
    //     if recWorkflow.FindFirst() then begin
    //         if (recWorkflow.Enable = true) then begin
    //             SubmitBool := false;
    //             SendApprBool := true;
    //             CancelApprBool := true;
    //         end
    //         else begin
    //             SubmitBool := true;
    //             SendApprBool := false;
    //             CancelApprBool := false;
    //         end
    //     end
    //     else
    //         SubmitBool := true;

    //     IF (Rec.Status = Rec.Status::Processed) then
    //         CurrPage.Editable(false)
    //     else
    //         CurrPage.Editable(true);
    //     ReqtoAppr.Reset();
    //     ReqtoAppr.SetFilter("Document No.", Rec."Document No.");
    //     ReqtoAppr.SetFilter("Approver ID", UserId());
    //     if ReqtoAppr.IsEmpty() then begin
    //         ApproveBool := false;
    //         RejectBool := false;



    //     end
    //     ELSE
    //         if Rec."Document No." <> '' then begin
    //             ApproveBool := true;
    //             RejectBool := true;
    //         end;
    //     Rec.SetRange("Document Type", Rec."Document Type"::Purchase);

    // end;


    trigger OnAfterGetRecord()
    var

    begin

        // ReqtoAppr.Reset();
        // ReqtoAppr.SetFilter("Document No.", Rec."Document No.");
        // ReqtoAppr.SetFilter("Approver ID", UserId());
        // if ReqtoAppr.IsEmpty() then begin
        //     ApproveBool := false;
        //     RejectBool := false;
        // end
        // ELSE
        //     if Rec."Document No." <> '' then begin
        //         ApproveBool := true;
        //         RejectBool := true;
        //     end;

    end;


}
#pragma implicitwith restore
