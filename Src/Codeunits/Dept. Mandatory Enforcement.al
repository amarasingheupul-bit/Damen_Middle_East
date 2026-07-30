codeunit 50114 "Dept. Mandatory Enforcement"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertGenJournalLine(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        CheckDepartmentMandatory(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyGenJournalLine(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        CheckDepartmentMandatory(Rec);
    end;

    local procedure CheckDepartmentMandatory(var GenJnlLine: Record "Gen. Journal Line")
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        if not CompanyInfo."Department Mandatory" then
            exit;

        if (GenJnlLine."Account No." = '') and (GenJnlLine.Amount = 0) then
            exit;

        if GenJnlLine."Shortcut Dimension 2 Code" = '' then
            Error('Department dimension is mandatory for journal lines in this company. Please contact your administrator if this is unexpected.');
    end;
}