page 50125 " Update Entries From Excel"

{
    PageType = Card;
    Caption = 'Update Related Data All files';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMID,
                    tabledata "Sales Invoice Header" = RIMD,
                    tabledata "Sales Invoice Line" = RIMD,
                    tabledata "Cust. Ledger Entry" = RIMD,
                    tabledata "Detailed Cust. Ledg. Entry" = RIMD,
                    tabledata "VAT Entry" = RIMD,
                    tabledata "Item Ledger Entry" = RIMD,
                    tabledata "Value Entry" = RIMD,
                    tabledata "Bank Account Ledger Entry" = RIMD,
                    tabledata "Vendor Ledger Entry" = RIMD,
                    tabledata "Detailed Vendor Ledg. Entry" = RIMD,
                    tabledata "Purch. Inv. Header" = RIMD,
                    tabledata "Purch. Inv. Line" = RIMD,
                    tabledata "Excel Data Import" = RIMD;

    // Legend;                              
    // G/L Entry  Update                    position  1  1   or 0    
    // Sales Invoice Header Update          position  2  1   or 0           
    // Sales Invoice Line Update            position  3  1   or 0    
    // Cust. Ledger Entry Update            position  4  1   or 0
    // Detailed Cust. Ledg. Entry Update    position  5  1   or 0
    // VAT Entry Update                     position  6  1   or 0
    // Item Ledger Entry Update             position  7  1   or 0
    // Value Entry Update                   position  8  1   or 0
    // Bank Account Ledger Entry Update     position  9  1   or 0
    // Purch. Inv. Header Update           position  10  1   or 0
    // Purch. Inv. Line Update             position  11  1   or 0
    // Vendor Ledger Entry Update          position  12  1   or 0
    // Detailed Vendor Ledg. Entry Update  position  13  1   or 0    



    actions
    {
        area(Processing)
        {
            action(UpdateData)
            {
                ApplicationArea = All;
                ToolTip = 'Tool Tip';
                Image = Process;

                trigger OnAction()
                begin

                    Message('Process Started');

                    this.ExcelData.SetRange("Entry No.", 1, 1000);
                    if this.ExcelData.FindSet() then
                        repeat

                            this.EntryNoInt := 0;
                            this.EntryNoInt := this.ExcelData."Entry##";

                            // Update GL Entry  (If Legend Position 1 = '1')-------------------------------------------------

                            Position := 1;
                            TargetChar := 0;

                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));


                            if TargetChar = 1 then begin
                                Message('Updating GL Entry');


                                this.GL.Reset();
                                this.GL.SetFilter(this.GL."Document No.", '%1', this.ExcelData."Document No.");
                                if this.GL.FindSet() then
                                    repeat

                                        if this.GL."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'G/LAccountNo' then begin
                                                this.GL."G/L Account No." := this.ExcelData."Value 4";
                                                this.GL.Modify(true);
                                            end;

                                            if this.ExcelData.UpdateField = 'Amount' then begin

                                                this.GL.Amount := this.ExcelData."Value 2";
                                                this.GL."VAT Amount" := this.ExcelData."Value 5";

                                                this.GL."Debit Amount" := 0;
                                                this.GL."Credit Amount" := 0;

                                                if this.ExcelData."Value 2" > 0 then
                                                    this.GL."Debit Amount" := this.ExcelData."Value 2";

                                                if this.ExcelData."Value 2" < 0 then
                                                    this.GL."Credit Amount" := this.ExcelData."Value 2" * -1;

                                                this.GL.Modify(true);

                                            end;


                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.GL."Posting Date", this.ExcelData."Value 3");
                                                this.GL.Modify(true);
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.GL."Document No.", this.ExcelData."Value 3");
                                                this.GL.Modify(true);
                                            end;


                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.GL.Delete();




                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.GL."Posting Date", this.ExcelData."Value 3");
                                                this.GL.Modify(true);
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.GL."Document No.", this.ExcelData."Value 3");
                                                this.GL.Modify(true);
                                            end;


                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.GL.Delete();


                                        end;

                                    until this.GL.Next() = 0;
                            end;

                            // Update bank ledger entry (if Legend Position 9 = '1')


                            Position := 9;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin

                                Message('Updating Bank Ledger Entry');

                                this.BNKLE.Reset();
                                this.BNKLE.SetFilter(this.BNKLE."Document No.", '%1', this.ExcelData."Document No.");
                                if this.BNKLE.FindSet() then
                                    repeat

                                        if this.BNKLE."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'Amount' then begin

                                                this.BNKLE.Amount := this.ExcelData."Value 2";
                                                this.BNKLE."Amount (LCY)" := this.ExcelData."Value 5";
                                                this.BNKLE."Remaining Amount" := this.ExcelData."Value 2";

                                                this.BNKLE."Debit Amount" := 0;
                                                this.BNKLE."Debit Amount (LCY)" := 0;
                                                this.BNKLE."Credit Amount" := 0;
                                                this.BNKLE."Credit Amount (LCY)" := 0;

                                                if this.ExcelData."Value 2" > 0 then
                                                    this.BNKLE."Debit Amount" := this.ExcelData."Value 2";
                                                this.BNKLE."Debit Amount (LCY)" := this.ExcelData."Value 5";

                                                if this.ExcelData."Value 2" < 0 then
                                                    this.BNKLE."Credit Amount" := this.ExcelData."Value 2";
                                                this.BNKLE."Credit Amount (LCY)" := this.ExcelData."Value 5";

                                                this.BNKLE.Modify();

                                            end;


                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.BNKLE."Posting Date", this.ExcelData."Value 3");
                                                this.BNKLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.BNKLE."Document No.", this.ExcelData."Value 3");
                                                this.BNKLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.BNKLE.Delete();


                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.BNKLE."Posting Date", this.ExcelData."Value 3");
                                                this.BNKLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.BNKLE."Document No.", this.ExcelData."Value 3");
                                                this.BNKLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.BNKLE.Delete();


                                        end;


                                    until this.BNKLE.Next() = 0;


                            end;

                            // Update VAT Entry (if Legend Position 6 = '1')

                            Position := 6;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating VAT Entry');

                                this.VATE.Reset();
                                this.VATE.SetFilter(this.VATE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.VATE.FindSet() then
                                    repeat

                                        if this.VATE."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'Amount' then begin

                                                this.VATE.Base := this.ExcelData."Value 2";
                                                this.VATE.Amount := this.ExcelData."Value 5";
                                                this.VATE."Base Before Pmt. Disc." := this.ExcelData."Value 2";

                                                this.VATE.Modify();

                                            end;

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.VATE."Posting Date", this.ExcelData."Value 3");
                                                this.VATE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.VATE."Document No.", this.ExcelData."Value 3");
                                                this.VATE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.VATE.Delete();


                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.VATE."Posting Date", this.ExcelData."Value 3");
                                                this.VATE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.VATE."Document No.", this.ExcelData."Value 3");
                                                this.VATE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.VATE.Delete();


                                        end;


                                    until this.VATE.Next() = 0;


                            end;

                            // Update Customer Ledger Entry (if Legend Position 4 = '1')

                            Position := 4;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Customer Ledger Entry');

                                this.CLE.Reset();
                                this.CLE.SetFilter(this.CLE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.CLE.FindSet() then
                                    repeat

                                        if this.CLE."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'Amount' then begin
                                                this.CLE.Amount := this.ExcelData."Value 2";
                                                this.CLE."Amount (LCY)" := this.ExcelData."Value 5";
                                                this.CLE."Remaining Amount" := this.ExcelData."Value 2";
                                                this.CLE."Original Amount" := this.ExcelData."Value 2";
                                                this.CLE."Original Amt. (LCY)" := this.ExcelData."Value 5";

                                                this.CLE."Debit Amount" := 0;
                                                this.CLE."Debit Amount (LCY)" := 0;
                                                this.CLE."Credit Amount" := 0;
                                                this.CLE."Credit Amount (LCY)" := 0;

                                                if this.ExcelData."Value 2" > 0 then begin
                                                    this.CLE."Debit Amount" := this.ExcelData."Value 2";
                                                    this.CLE."Debit Amount (LCY)" := this.ExcelData."Value 5";
                                                end;

                                                if this.ExcelData."Value 2" < 0 then begin
                                                    this.CLE."Credit Amount" := this.ExcelData."Value 2";
                                                    this.CLE."Credit Amount (LCY)" := this.ExcelData."Value 5";
                                                end;

                                                this.CLE.Modify();

                                            end;

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.CLE."Posting Date", this.ExcelData."Value 3");
                                                this.CLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.CLE."Document No.", this.ExcelData."Value 3");
                                                this.CLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.CLE.Delete();


                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.CLE."Posting Date", this.ExcelData."Value 3");
                                                this.CLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.CLE."Document No.", this.ExcelData."Value 3");
                                                this.CLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.CLE.Delete();


                                        end;

                                    until this.CLE.Next() = 0;

                            end;

                            // Update Detailed Customer Ledger Entry (if Legend Position 5 = '1')


                            Position := 5;
                            TargetChar := 0;
                            if evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1)) then
                                if TargetChar = 1 then begin
                                    Message('Updating Detailed Customer Ledger Entry');

                                    this.DCLE.Reset();
                                    this.DCLE.SetFilter(this.DCLE."Document No.", '%1', this.ExcelData."Document No.");
                                    if this.DCLE.FindSet() then
                                        repeat
                                            if this.DCLE."Entry No." = this.EntryNoInt then begin

                                                if this.ExcelData.UpdateField = 'Amount' then begin
                                                    this.DCLE.Amount := this.ExcelData."Value 2";
                                                    this.DCLE."Amount (LCY)" := this.ExcelData."Value 5";

                                                    this.DCLE."Debit Amount" := 0;
                                                    this.DCLE."Debit Amount (LCY)" := 0;
                                                    this.DCLE."Credit Amount" := 0;
                                                    this.DCLE."Credit Amount (LCY)" := 0;

                                                    if this.ExcelData."Value 2" > 0 then begin
                                                        this.DCLE."Debit Amount" := this.ExcelData."Value 2";
                                                        this.DCLE."Debit Amount (LCY)" := this.ExcelData."Value 5";
                                                    end;

                                                    if this.ExcelData."Value 2" < 0 then begin
                                                        this.DCLE."Credit Amount" := this.ExcelData."Value 2";
                                                        this.DCLE."Credit Amount (LCY)" := this.ExcelData."Value 5";
                                                    end;

                                                    this.DCLE.Modify();

                                                end;

                                                if this.ExcelData.UpdateField = 'PostDate' then begin
                                                    evaluate(this.DCLE."Posting Date", this.ExcelData."Value 3");
                                                    this.DCLE.Modify();
                                                end;

                                                if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                    evaluate(this.DCLE."Document No.", this.ExcelData."Value 3");
                                                    this.DCLE.Modify();
                                                end;

                                                if this.ExcelData.UpdateField = 'Delete' then
                                                    this.DCLE.Delete();


                                            end else begin

                                                if this.ExcelData.UpdateField = 'PostDate' then begin
                                                    evaluate(this.DCLE."Posting Date", this.ExcelData."Value 3");
                                                    this.DCLE.Modify();
                                                end;

                                                if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                    evaluate(this.DCLE."Document No.", this.ExcelData."Value 3");
                                                    this.DCLE.Modify();
                                                end;

                                                if this.ExcelData.UpdateField = 'Delete' then
                                                    this.DCLE.Delete();

                                            end;

                                        until this.DCLE.Next() = 0;

                                end;


                            // Update Item Ledger Entry (if Legend Position 7 = '1')

                            Position := 7;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Item Ledger Entry');



                                this.ILE.Reset();
                                this.ILE.SETRANGE(this.ILE."Entry Type", this.ILE."Entry Type"::Purchase);
                                this.ILE.SetFilter(this.ILE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.ILE.FindSet() then
                                    repeat
                                        if this.ExcelData.UpdateField = 'PostDate' then
                                            evaluate(this.ILE."Posting Date", this.ExcelData."Value 3");

                                        if this.ExcelData.UpdateField = 'DocumentNo' then
                                            evaluate(this.ILE."Document No.", this.ExcelData."Value 3");


                                        this.ILE.Modify();
                                    until this.ILE.Next() = 0;
                            end;

                            // Update Value Entry (if Legend Position 8 = '1')

                            Position := 8;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Value Entry');

                                this.VALE.Reset();

                                this.VALE.SetFilter(this.VALE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.VALE.FindSet() then
                                    repeat

                                        if this.VALE."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'Amount' then begin

                                                this.VALE."Cost Amount (Actual)" := this.ExcelData."Value 2";
                                                this.VALE."Cost Posted to G/L" := this.ExcelData."Value 2";
                                                this.VALE."Cost per Unit" := this.ExcelData."Value 5";

                                                this.VALE.Modify();

                                            end;

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.VALE."Posting Date", this.ExcelData."Value 3");
                                                this.VALE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.VALE."Document No.", this.ExcelData."Value 3");
                                                this.VALE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.VALE.Delete();


                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.VALE."Posting Date", this.ExcelData."Value 3");
                                                this.VALE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.VALE."Document No.", this.ExcelData."Value 3");
                                                this.VALE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.VALE.Delete();

                                        end;

                                    until this.VALE.Next() = 0;
                            end;

                            // Update Sales Invoice Header and Line (if Legend Position 2 and 3 = '1')

                            Position := 3;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Sales Invoice Line');


                                this.SINVLINE.Reset();
                                this.SINVLINE.SetFilter(this.SINVLINE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.SINVLINE.FindSet() then
                                    repeat

                                        if this.ExcelData.UpdateField = 'PostDate' then
                                            evaluate(this.SINVLINE."Posting Date", this.ExcelData."Value 3");

                                        this.TempSINVLINE.Reset();
                                        if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                            // Create temporary copy of the record
                                            this.TempSINVLINE := this.SINVLINE;
                                            this.SINVLINE.Delete();
                                            this.SINVLINE := this.TempSINVLINE;
                                            this.SINVLINE."Document No." := this.ExcelData."Value 3";
                                            this.SINVLINE.Insert();
                                        end;

                                    until this.SINVLINE.Next() = 0;
                            end;

                            Position := 2;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Sales Invoice Header');


                                this.SINVHDR.Reset();
                                this.SINVHDR.SetFilter(this.SINVHDR."No.", '%1', this.ExcelData."Document No.");

                                if this.SINVHDR.FindSet() then begin


                                    if this.ExcelData.UpdateField = 'PostDate' then
                                        evaluate(this.SINVHDR."Posting Date", this.ExcelData."Value 3");


                                    if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                        // Create temporary copy of the record
                                        this.TempSINVHDR := this.SINVHDR;

                                        // Delete old record
                                        this.SINVHDR.Delete();

                                        // Create new record with new doc number
                                        this.SINVHDR := this.TempSINVHDR;
                                        this.SINVHDR."No." := this.ExcelData."Value 3";
                                        this.SINVHDR.Insert();

                                    end;

                                end;


                            end;


                            // Update Vendor Ledger Entry (if Legend Position 12 = '1')

                            Position := 12;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Vendor Ledger Entry');

                                this.VLE.Reset();
                                this.VLE.SetFilter(this.VLE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.VLE.FindSet() then
                                    repeat

                                        if this.VLE."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'Amount' then begin
                                                this.VLE.Amount := this.ExcelData."Value 2";
                                                this.VLE."Amount (LCY)" := this.ExcelData."Value 5";
                                                this.VLE."Remaining Amount" := this.ExcelData."Value 2";
                                                this.VLE."Original Amount" := this.ExcelData."Value 2";
                                                this.VLE."Original Amt. (LCY)" := this.ExcelData."Value 5";

                                                this.VLE."Debit Amount" := 0;
                                                this.VLE."Debit Amount (LCY)" := 0;
                                                this.VLE."Credit Amount" := 0;
                                                this.VLE."Credit Amount (LCY)" := 0;

                                                if this.ExcelData."Value 2" > 0 then begin
                                                    this.VLE."Debit Amount" := this.ExcelData."Value 2";
                                                    this.VLE."Debit Amount (LCY)" := this.ExcelData."Value 5";
                                                end;

                                                if this.ExcelData."Value 2" < 0 then begin
                                                    this.VLE."Credit Amount" := this.ExcelData."Value 2";
                                                    this.VLE."Credit Amount (LCY)" := this.ExcelData."Value 5";
                                                end;

                                                this.VLE.Modify();

                                            end;

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.VLE."Posting Date", this.ExcelData."Value 3");
                                                this.VLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.VLE."Document No.", this.ExcelData."Value 3");
                                                this.VLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.VLE.Delete();


                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.VLE."Posting Date", this.ExcelData."Value 3");
                                                this.VLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.VLE."Document No.", this.ExcelData."Value 3");
                                                this.VLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.VLE.Delete();


                                        end;

                                    until this.VLE.Next() = 0;

                            end;

                            // Update Detailed Vendor Ledger Entry (if Legend Position 13 = '1')


                            Position := 13;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Detailed Vendor Ledger Entry');


                                this.DVLE.Reset();
                                this.DVLE.SetFilter(this.DVLE."Document No.", '%1', this.ExcelData."Document No.");
                                if this.DVLE.FindSet() then
                                    repeat
                                        if this.DVLE."Entry No." = this.EntryNoInt then begin

                                            if this.ExcelData.UpdateField = 'Amount' then begin
                                                this.DVLE.Amount := this.ExcelData."Value 2";
                                                this.DVLE."Amount (LCY)" := this.ExcelData."Value 5";

                                                this.DVLE."Debit Amount" := 0;
                                                this.DVLE."Debit Amount (LCY)" := 0;
                                                this.DVLE."Credit Amount" := 0;
                                                this.DVLE."Credit Amount (LCY)" := 0;

                                                if this.ExcelData."Value 2" > 0 then begin
                                                    this.DVLE."Debit Amount" := this.ExcelData."Value 2";
                                                    this.DVLE."Debit Amount (LCY)" := this.ExcelData."Value 5";
                                                end;

                                                if this.ExcelData."Value 2" < 0 then begin
                                                    this.DVLE."Credit Amount" := this.ExcelData."Value 2";
                                                    this.DVLE."Credit Amount (LCY)" := this.ExcelData."Value 5";
                                                end;

                                                this.DVLE.Modify();

                                            end;

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.DVLE."Posting Date", this.ExcelData."Value 3");
                                                this.DVLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.DVLE."Document No.", this.ExcelData."Value 3");
                                                this.DVLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.DVLE.Delete();


                                        end else begin

                                            if this.ExcelData.UpdateField = 'PostDate' then begin
                                                evaluate(this.DVLE."Posting Date", this.ExcelData."Value 3");
                                                this.DVLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                                evaluate(this.DVLE."Document No.", this.ExcelData."Value 3");
                                                this.DVLE.Modify();
                                            end;

                                            if this.ExcelData.UpdateField = 'Delete' then
                                                this.DVLE.Delete();


                                        end;

                                    until this.DVLE.Next() = 0;

                            end;

                            // Update Purchase Invoice Header and Line (if Legend Position 10 and 11 = '1')

                            Position := 11;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Purchase Invoice Line');

                                this.PINVLINE.Reset();
                                this.PINVLINE.SetFilter(this.PINVLINE."Document No.", '%1', this.ExcelData."Document No.");

                                if this.PINVLINE.FindSet() then
                                    repeat

                                        if this.ExcelData.UpdateField = 'PostDate' then
                                            evaluate(this.PINVLINE."Posting Date", this.ExcelData."Value 3");

                                        this.PINVLINE.Modify();

                                        if this.ExcelData.UpdateField = 'Amount' then begin
                                            this.PINVLINE.Amount := this.ExcelData."Value 2";
                                            this.PINVLINE."Amount Including VAT" := this.ExcelData."Value 2";
                                            this.PINVLINE."Line Amount" := this.ExcelData."Value 2";

                                            this.PINVLINE.Modify();
                                        end;

                                        this.TempPINVLINE.Reset();
                                        if this.ExcelData.UpdateField = 'DocumentNo' then begin

                                            // Create temporary copy of the record
                                            this.TempPINVLINE := this.PINVLINE;
                                            this.PINVLINE.Delete();
                                            this.PINVLINE := this.TempPINVLINE;
                                            this.PINVLINE."Document No." := this.ExcelData."Value 3";
                                            this.PINVLINE.Insert();
                                        end;

                                    until this.PINVLINE.Next() = 0;
                            end;

                            Position := 11;
                            TargetChar := 0;
                            evaluate(TargetChar, CopyStr(this.ExcelData."Legend", Position, 1));
                            if TargetChar = 1 then begin
                                Message('Updating Purchase Invoice Header');


                                this.PINVHDR.Reset();
                                this.PINVHDR.SetFilter(this.PINVHDR."No.", '%1', this.ExcelData."Document No.");

                                if this.PINVHDR.FindSet() then begin

                                    if this.ExcelData.UpdateField = 'PostDate' then begin
                                        evaluate(this.PINVHDR."Posting Date", this.ExcelData."Value 3");

                                        this.PINVHDR.Modify();

                                    end;

                                    if this.ExcelData.UpdateField = 'Amount' then begin
                                        this.PINVHDR.Amount := this.ExcelData."Value 2";
                                        this.PINVHDR."Amount Including VAT" := this.ExcelData."Value 2";
                                        this.PINVHDR."Currency Factor" := 4.27525;


                                        this.PINVHDR.Modify();
                                    end;


                                    if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                        // Create temporary copy of the record
                                        this.TempPINVHDR := this.PINVHDR;

                                        // Delete old record
                                        this.PINVHDR.Delete();

                                        // Create new record with new doc number
                                        this.PINVHDR := this.TempPINVHDR;
                                        this.PINVHDR."No." := this.ExcelData."Value 3";
                                        this.PINVHDR.Insert();

                                    end;

                                end;


                            end;




                        until this.ExcelData.Next() = 0;


                    Message('Process Finished');
                end;



            }

        }
    }

    var

        TempSINVHDR: Record "Sales Invoice Header" temporary;
        TempSINVLINE: Record "Sales Invoice Line" temporary;
        TempPINVHDR: Record "Purch. Inv. Header" temporary;
        TempPINVLINE: Record "Purch. Inv. Line" temporary;
        ExcelData: Record "Excel Data Import";
        GL: Record "G/L Entry";
        BNKLE: Record "Bank Account Ledger Entry";
        CLE: Record "Cust. Ledger Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        SINVHDR: Record "Sales Invoice Header";
        SINVLINE: Record "Sales Invoice Line";
        VATE: Record "VAT Entry";
        ILE: Record "Item Ledger Entry";
        VALE: Record "Value Entry";

        VLE: Record "Vendor Ledger Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";

        PINVHDR: Record "Purch. Inv. Header";
        PINVLINE: Record "Purch. Inv. Line";


        EntryNoInt: Integer;

        TargetChar: Integer;
        Position: Integer;


    //  CharacterAtIndex := Mid(MyString, 2, 1);

}