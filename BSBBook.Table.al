/// <summary>
/// Table BSB Book (ID 50100).
/// </summary>
table 50100 "BSB Book"
{
    // [x] Ein Buch darf nicht gelöscht
    // [x] Prüfung auf gesperrtes Buch
    Caption = 'Book';
    DataCaptionFields = "No.", Description;
    LookupPageId = "BSB Book List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := CopyStr(Description, 1, MaxStrLen("Search Description"));
            end;
        }
        field(3; "Search Description"; Code[100])
        {
            //[x] Automatisch versorgen/sync
            Caption = 'Search Description';
        }
        field(4; Blocked; Boolean) { Caption = 'Blocked'; }
        field(5; Type; Enum "BSB Book Type")
        {
            Caption = 'Type';
            // OptionMembers = " ",Hardcover,Paperback;
            // OptionCaption = ' ,Hardcover,Paperback';
        }
        field(7; Created; Date)
        {
            Caption = 'Created';
            Editable = false;
            //[x] Wird automatisch bestückt
        }
        field(8; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            //[x] Wird automatisch bestückt

        }
        field(10; Author; Text[50]) { Caption = 'Author'; }
        field(11; "Author Provision %"; Decimal)
        {
            Caption = 'Author Provision %';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
        }
        field(15; ISBN; Code[20]) { Caption = 'ISBN'; }
        field(16; "No. of Pages"; Integer)
        {
            Caption = 'No. of Pages';
            MinValue = 0;
        }
        field(17; "Edition No."; Integer)
        {
            Caption = 'Edition No.';
            MinValue = 0;
        }
        field(18; "Date of Publishing"; Date) { Caption = 'Date of Publishing'; }
    }
    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, Author) { }
    }
    trigger OnInsert()
    begin
        Created := Today;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnDelete()
    begin
        Error(OnDeleteBookErr);
    end;

    #region Testblocked
    /// <summary>
    /// Throw an error, if Book is blocked
    /// </summary>
    procedure TestBlocked()
    begin
        TestBlocked(Rec);
    end;

    /// <summary>
    /// First try to read the Boo record with given No-Parameter. Throw an error, if Book is blocked
    /// </summary>
    /// <param name="No">Code[20].</param>
    procedure TestBlocked(No: Code[20])
    var
        BSBBook: Record "BSB Book";
    begin
        if not BSBBook.Get(No) then
            exit;
        TestBlocked(BSBBook);
    end;

    local procedure TestBlocked(var BSBBook: Record "BSB Book")
    begin
        BSBBook.TestField(Blocked, false);
    end;
    #endregion Testblocked

    procedure ShowCard()
    begin
        ShowCard(Rec);
    end;

    procedure ShowCard(BookNo: Code[20])
    var
        BSBBook: Record "BSB Book";
    begin
        if not BSBBook.Get(BookNo) then
            exit;
        ShowCard(BSBBook);
    end;

    local procedure ShowCard(var BSBBook: Record "BSB Book")
    begin
        Page.Run(Page::"BSB Book Card", BSBBook);
    end;

    var
        OnDeleteBookErr: label 'A Book cannot be deleted';
}