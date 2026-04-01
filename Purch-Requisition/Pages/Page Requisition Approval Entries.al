#pragma implicitwith disable
page 50168 "Req. Approval Entries_IXO"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Requisition Approval Entries';
    SourceTable = "Req. Approval Entries_IXO";
    AdditionalSearchTerms = 'Req Approval Entries';
    Editable = false;
    // SourceTableView = sorting ("Entry No.") where (Status = filter (Open), "Approver ID" = filter ("User ID Filter"));



    layout
    {
        area(Content)
        {
            repeater("Approval Entries")
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }

                /*  field("Record ID to Approve"; "Record ID to Approve")
                 {
                     ApplicationArea = All;
                 } */
                /*  field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                 {
                     ApplicationArea = All;
                 } */
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                /*  field("Sequence No."; "Sequence No.")
                 {
                     ApplicationArea = All;
                 } */
                /*  field(Status; Status)
                 {
                     ApplicationArea = All;
                 } */
                /*   field("Table ID"; "Table ID")
                  {
                      ApplicationArea = All;
                  } */
                /*  field("Workflow Step Instance ID"; "Workflow Step Instance ID")
                 {
                     ApplicationArea = All;
                 } */

                /*  field("Approval Code"; "Approval Code")
                 {
                     ApplicationArea = All;
                 } */
                /*   field("Approver ID"; "Approver ID")
                  {
                      ApplicationArea = All;
                  } */
                /*  field("Available Credit Limit (LCY)"; "Available Credit Limit (LCY)")
                 {
                     ApplicationArea = All;
                 } */
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Open Record")
            {
                ApplicationArea = All;
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Cont: Record "Purchase Req. Header_IXO";
                begin
                    if Rec."Document Type" = Rec."Document Type"::Material then begin
                        Cont.SetRange("Document Type", Rec."Document Type"::Material);
                        Cont.SetRange("Document No.", Rec."Document No.");
                        CONT.FindFirst();
                        page.Run(page::"Material Requisition Card_IXO", Cont)
                    end
                    else
                        if Rec."Document Type" = Rec."Document Type"::Purchase then begin
                            Cont.SetRange("Document Type", Rec."Document Type"::Purchase);
                            Cont.SetRange("Document No.", Rec."Document No.");
                            CONT.FindFirst();
                            page.Run(page::"Purchase Requisition Card_IXO", Cont);

                        end;

                END;
            }
            action("Approve")
            {
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Cont1: Record "Req. Approval Entries_IXO";
                    Cont2: Record "Purchase Req. Header_IXO";
                    WrkFlw: Record "Workflow User Group Member";
                    Seq: Integer;


                begin
                    Cont1.Reset();
                    Cont1.SetCurrentKey("Sequence No.");
                    Cont1.SetFilter("Document No.", Rec."Document No.");
                    Cont1.SetRange("Document Type", Rec."Document Type");
                    Cont1.SetFilter(Status, '%1|%2', Rec.Status::Open, Rec.Status::Created);
                    Cont1.SetAscending("Sequence No.", true);
                    IF Cont1.FindSet() THEN begin
                        repeat
                            IF Cont1.Status = Cont1.Status::Open then begin

                                Cont1.Status := Cont1.Status::Approved;
                                Cont1.Modify();
                                Seq := Cont1."Sequence No.";
                            End;
                            IF (Cont1.Status = Cont1.Status::Created) AND (Cont1."Sequence No." = Seq + 1) then begin

                                Cont1.Status := Cont1.Status::Open;
                                Cont1.Modify();

                            end;

                        until Cont1.Next() = 0;
                        WrkFlw.Reset();
                        WrkFlw.SetCurrentKey("Sequence No.");
                        WrkFlw.SetRange(WrkFlw."Workflow User Group Code", Rec."Approval Code");
                        WrkFlw.SetAscending("Sequence No.", true);
                        IF WrkFlw.FindLast() then begin
                            IF WrkFlw."Sequence No." = Seq then
                                Cont2.Reset();
                            Cont2.SetFilter("Document No.", Rec."Document No.");
                            Cont2.SetRange("Document Type", Rec."Document Type");
                            IF Cont2.FindFirst() then begin
                                Cont2.Status := Cont2.Status::Approved;
                                Cont2.Modify();
                            end;
                        end;
                    end;
                END;
            }

            action("Reject")
            {
                ApplicationArea = All;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recPurchReqLine: Record "Purchase Req. Header_IXO";
                begin
                    Rec.Status := Rec.Status::Rejected;
                    Rec.Modify();
                    recPurchReqLine.SetFilter("Document No.", Rec."Document No.");
                    IF recPurchReqLine.FindFirst() then begin
                        recPurchReqLine.Status := recPurchReqLine.Status::Rejected;
                        recPurchReqLine.Modify();
                    end;
                end;
            }
        }
    }

    var

    trigger OnOpenPage()
    begin
        // SetRange("Approver ID", UserId());
        Rec.Setrange("Approver ID", UserId());
        // SetFilter(Status, 'Open');
        // A change made at local machine.

        // SetFILTER("User ID Filter", UserId());
        Rec.Setrange(Status, Rec.Status::Open);
    end;
}
#pragma implicitwith restore
