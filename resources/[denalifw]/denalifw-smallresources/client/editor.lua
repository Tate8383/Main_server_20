RegisterCommand("record", function(source , args)
    StartRecording(1)
    DenaliFW.Functions.Notify("Started Recording!", "success")
end)

RegisterCommand("clip", function(source , args)
    StartRecording(0)
end)

RegisterCommand("saveclip", function(source , args)
    StopRecordingAndSaveClip()
    DenaliFW.Functions.Notify("Saved Recording!", "success")
end)

RegisterCommand("delclip", function(source , args)
    StopRecordingAndDiscardClip()
    DenaliFW.Functions.Notify("Deleted Recording!", "error")
end)

RegisterCommand("editor", function(source , args)
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
    DenaliFW.Functions.Notify("Later aligator!", "error")
end)
