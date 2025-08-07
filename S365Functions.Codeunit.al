codeunit 50102 S365Functions
{
    trigger OnRun()
    begin
    end;
    procedure SalesQuoteAmendArchive(var Rec: Record "Sales Header")
    var
        // CopySalesDoc: Report "Copy Sales Document";
        SalesHeader: Record "Sales Header";
        CopyDocumentMgt: Codeunit "Copy Document Mgt.";
        DocNo: Code[20];
        DocNoLbl: Label '%1-%2', Comment = '%1=Sales Quote No. %2=increment';
    begin
        this.IsQoutePrintedEmail(Rec);
        this.SetCurrQouteArchive(Rec);
        SalesHeader.Init();
        SalesHeader."Document Type":=SalesHeader."Document Type"::Quote;
        DocNo:=StrSubstNo(DocNoLbl, Rec."No.", this.GetLastIncr(Rec));
        SalesHeader."No.":=DocNo;
        SalesHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesHeader."Original Quote No. S365":=Rec."No.";
        SalesHeader.Insert(true);
        CopyDocumentMgt.CopySalesDoc(Rec."Document Type", Rec."No.", SalesHeader);
    end;
    local procedure GetLastIncr(var Rec: Record "Sales Header"): Text[20]var
        SalesQuotes: Record "Sales Header";
        HyphenPos: Integer;
    begin
        SalesQuotes.Reset();
        SalesQuotes.SetRange("Original Quote No. S365", Rec."No.");
        if SalesQuotes.FindLast()then begin
            HyphenPos:=StrPos(SalesQuotes."No.", '-');
            if HyphenPos > 0 then exit(CopyStr(SalesQuotes."No.", HyphenPos + 1, MaxStrLen(SalesQuotes."No."))); // Return the substring after the hyphen
            exit('1'); // Return an 1 string if no hyphen is found
        end;
    end;
    local procedure IsQoutePrintedEmail(var Rec: Record "Sales Header")
    begin
        if Rec."Printed or Email S365" then Rec.TestField("Change Reason S365")
        else
            Rec.TestField("Printed or Email S365");
    end;
    local procedure SetCurrQouteArchive(var Rec: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.ArchiveSalesDocument(Rec);
    end;
}
