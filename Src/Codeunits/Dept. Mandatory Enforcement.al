codeunit 50114 "Dept. Mandatory Enforcement"
{
    // ------------------------------------------------------------------
    // General Journal posting
    // ------------------------------------------------------------------
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; var Posted: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var PostingGenJournalLine: Record "Gen. Journal Line")
    var
        SkipCheck: Boolean;
    begin
        // Skip blank/placeholder lines (no account, no amount)
        SkipCheck := (GenJournalLine."Account No." = '') and (GenJournalLine.Amount = 0);

        CheckDepartmentMandatory(GenJournalLine."Shortcut Dimension 2 Code", SkipCheck);
        CheckEmployeeMandatory(GenJournalLine.Employee, SkipCheck);
    end;

    // ------------------------------------------------------------------
    // Sales Invoice posting
    // ------------------------------------------------------------------
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterTestSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnAfterTestSalesLine(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var WhseShptHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean; PreviewMode: Boolean; var CostBaseAmount: Decimal)
    begin
        // Only enforce on Invoice postings, per requirement
        if SalesLine."Document Type" <> SalesLine."Document Type"::Invoice then
            exit;

        CheckDepartmentMandatorySale(SalesLine."Shortcut Dimension 2 Code", false);
        CheckEmployeeMandatorySale(SalesLine.Employee, false);
    end;

    // ------------------------------------------------------------------
    // Purchase Invoice posting
    // ------------------------------------------------------------------
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchLine', '', false, false)]
    local procedure OnAfterPostPurchLine(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; CommitIsSupressed: Boolean; var PurchInvLine: Record "Purch. Inv. Line"; var PurchCrMemoLine: Record "Purch. Cr. Memo Line"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchLineACY: Record "Purchase Line"; GenJnlLineDocType: Enum "Gen. Journal Document Type"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; SrcCode: Code[10]; xPurchaseLine: Record "Purchase Line")
    begin
        if PurchaseLine."Document Type" <> PurchaseLine."Document Type"::Invoice then
            exit;

        CheckDepartmentMandatorySale(PurchaseLine."Shortcut Dimension 2 Code", false);
        CheckEmployeeMandatorySale(PurchaseLine.Employee, false);
    end;

    // ------------------------------------------------------------------
    // Shared check logic
    // ------------------------------------------------------------------
    local procedure CheckDepartmentMandatory(DimensionValue: Code[20]; SkipCheck: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        if not CompanyInfo."Department Mandatory" then
            exit;

        if SkipCheck then
            exit;

        if DimensionValue = '' then
            Error(DepartmentMandatoryErr);
    end;

    local procedure CheckEmployeeMandatory(EmployeeValue: Code[20]; SkipCheck: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        if not CompanyInfo."Employee Mandatory" then
            exit;

        if SkipCheck then
            exit;

        if EmployeeValue = '' then
            Error(EmployeeMandatoryErr);
    end;


    local procedure CheckDepartmentMandatorySale(DimensionValue: Code[20]; SkipCheck: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        if not CompanyInfo."Department Mandatory" then
            exit;

        if SkipCheck then
            exit;

        if DimensionValue = '' then
            Error(DepartmentMandatorySaleErr);
    end;

    local procedure CheckEmployeeMandatorySale(EmployeeValue: Code[20]; SkipCheck: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        if not CompanyInfo."Employee Mandatory" then
            exit;

        if SkipCheck then
            exit;

        if EmployeeValue = '' then
            Error(EmployeeMandatorySaleErr);
    end;

    var
        DepartmentMandatoryErr: Label 'Department dimension is mandatory for journal lines in this company. Please contact your administrator if this is unexpected.';
        EmployeeMandatoryErr: Label 'Employee dimension is mandatory for journal lines in this company. Please contact your administrator if this is unexpected.';

        DepartmentMandatorySaleErr: Label 'Department dimension is mandatory for  this company. Please contact your administrator if this is unexpected.';
        EmployeeMandatorySaleErr: Label 'Employee dimension is mandatory for this company. Please contact your administrator if this is unexpected.';
}