; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#include "idp\idp.iss"

#define MyAppName "obs-ndi"
#define MyAppVersion "4.8.0"
#define MyAppPublisher "Stephane Lepin"
#define MyAppURL "http://github.com/Palakis/obs-ndi"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{69FA0C71-8BEB-4E0D-B5D2-53BFF9192EE2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={code:GetDirName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=obs-ndi-Windows-Installer
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "main"; Description: "NDI Plugin for OBS Studio"; Types: full custom; Flags: fixed
Name: "ndiruntime"; Description: "NDI Runtime (required by the plugin)"; Types: full custom

[Files]
Source: "..\release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\LICENSE"; Flags: dontcopy
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Run]
Filename: "{tmp}\ndi-redist-installer.exe"; StatusMsg: "Install NDI Runtime..."; Components: ndiruntime; Flags: hidewizard

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Code]
const
  ndiRedistURL = 'http://new.tk/NDIRedistV4';

procedure InitializeWizard;
var
  GPLText: AnsiString;
  Page: TOutputMsgMemoWizardPage;
begin
  ExtractTemporaryFile('LICENSE');
  LoadStringFromFile(ExpandConstant('{tmp}\LICENSE'), GPLText);

  Page := CreateOutputMsgMemoPage(wpWelcome,
    'License Information', 'Please review the license terms before installing obs-websocket',
    'Press Page Down to see the rest of the agreement. Once you are aware of your rights, click Next to continue.',
    String(GPLText)
  );

  idpAddFileComp(ndiRedistUrl, ExpandConstant('{tmp}\ndi-redist-installer.exe'), 'ndiruntime');
  idpDownloadAfter(wpReady);
end;

// credit where it's due :
// following function comes from https://github.com/Xaymar/obs-studio_amf-encoder-plugin/blob/master/%23Resources/Installer.in.iss#L45
function GetDirName(Value: string): string;
var
  InstallPath: string;
begin
  // initialize default path, which will be returned when the following registry
  // key queries fail due to missing keys or for some different reason
  Result := '{pf}\obs-studio';
  // query the first registry value; if this succeeds, return the obtained value
  if RegQueryStringValue(HKLM32, 'SOFTWARE\OBS Studio', '', InstallPath) then
    Result := InstallPath
end;

