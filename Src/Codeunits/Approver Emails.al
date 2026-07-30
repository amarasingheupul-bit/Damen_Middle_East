codeunit 50108 "4HC Backfill Approver Emails"
{
    trigger OnRun()
    var
        PurchHeader: Record "Purchase Header";
        Contact: Record Contact;
    begin
        if PurchHeader.FindSet(true) then
            repeat
                // Backfill Approver 1 Email
                if (PurchHeader."Purchaser Code" <> '') and
                   (PurchHeader."External Approver 1 Email" = '') then
                    if Contact.Get(PurchHeader."Purchaser Code") then begin
                        PurchHeader."External Approver 1 Email" := Contact."E-Mail";
                        PurchHeader.Modify(false);
                    end;

                // Backfill Approver 2 Email
                if (PurchHeader."External Approver 2 No." <> '') and
                   (PurchHeader."External Approver 2 Email" = '') then
                    if Contact.Get(PurchHeader."External Approver 2 No.") then begin
                        PurchHeader."External Approver 2 Email" := Contact."E-Mail";
                        PurchHeader.Modify(false);
                    end;
            until PurchHeader.Next() = 0;
    end;
}