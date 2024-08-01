codeunit 50101 "BSB Company Info. Wizard Meth"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddExtensionAssistedSetup_OnRegisterAssistedSetup();
    var
        GuidedExperience: Codeunit "Guided Experience";
        CurrentGlobalLanguage: Integer;
        WizardTitleTxt: label 'Company Information Setup';
        WizardDescTxt: label 'Provide the Name and E-Mail of your Compamny.';
    begin
        CurrentGlobalLanguage := GlobalLanguage();
        GuidedExperience.InsertAssistedSetup(
            WizardTitleTxt, '', WizardDescTxt, 2,
            ObjectType::Page, GetPageId(), "Assisted Setup Group"::Extensions,
            '', "Video Category"::Extensions, '');
        GlobalLanguage(1033);
        GuidedExperience.AddTranslationForSetupObjectTitle(
            "Guided Experience Type"::"Assisted Setup",
            ObjectType::Page, GetPageId(), 1033, WizardTitleTxt);
        GuidedExperience.AddTranslationForSetupObjectDescription(
            "Guided Experience Type"::"Assisted Setup",
            ObjectType::Page, GetPageId(), 1033, WizardDescTxt);
        GlobalLanguage(CurrentGlobalLanguage);

        UpdateStatus();
    end;

    //TODO: remove the following subscriber if not necessary to run
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnReRunOfCompletedAssistedSetup', '', false, false)]
    local procedure OnReRunOfCompletedSetup(ExtensionID: Guid; ObjectType: ObjectType; ObjectID: Integer; var Handled: Boolean)
    var
        SetupAlreadyDoneQst: Label 'This setup is already done. Do you want to open the setup page instead?';
    begin
        if ExtensionId <> GetAppId() then exit;
        if ObjectID <> GetPageId() then exit;

        if Confirm(SetupAlreadyDoneQst, true) then begin
            Page.Run(Page::"Company Information"); //TODO: Might have to be be a different page (like not the wizard, but the setup page instead)
            Handled := true;
        end;
    end;

    //TODO: remove the following subscriber if not necessary to run 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnAfterRunAssistedSetup', '', false, false)]
    local procedure OnAfterRunOfSetup(ExtensionID: Guid; ObjectType: ObjectType; ObjectID: Integer)
    begin
        if ExtensionId <> GetAppId() then exit;
        if ObjectID <> GetPageId() then exit;

        UpdateStatus();
        //TODO: put code here to run 'OnAfterRunAssistedSetup' 
    end;

    procedure UpdateStatus()
    var
        Rec: Record "Company Information";
        GuidedExperience: Codeunit "Guided Experience";
    begin
        if not Rec.Get() then exit;

        if (Rec.Name <> '') and (Rec."E-Mail" <> '') then
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, GetPageId())
        else
            GuidedExperience.ResetAssistedSetup(ObjectType::Page, GetPageId());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Company Information", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifySourceTable()
    begin
        UpdateStatus();
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
        Info: ModuleInfo;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;

    local procedure GetPageId(): Integer
    begin
        exit(page::"BSB Company Information Wizard");
    end;

    //TODO: Call "SomeAssistedSetup.UpdateStatus(); in case the wizard is run without the assisted setup.  It should call the "UpdateStatus" of this codeunit.
    [EventSubscriber(ObjectType::Page, Page::"Company Information", 'OnModifyRecordEvent', '', false, false)]
    local procedure OnModifyRecordCompanyInformation()
    begin
        UpdateStatus();
    end;
}
