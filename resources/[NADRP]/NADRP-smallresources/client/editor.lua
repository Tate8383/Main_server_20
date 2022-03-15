RegisterCommand("record", function(source , args)
    StartRecording(1)
    NADRP.Functions.Notify("Started Recording!", "success")
end)

RegisterCommand("clip", function(source , args)
    StartRecording(0)
end)

RegisterCommand("saveclip", function(source , args)
    StopRecordingAndSaveClip()
    NADRP.Functions.Notify("Saved Recording!", "success")
end)

RegisterCommand("delclip", function(source , args)
    StopRecordingAndDiscardClip()
    NADRP.Functions.Notify("Deleted Recording!", "error")
end)

RegisterCommand("editor", function(source , args)
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
    NADRP.Functions.Notify("Later aligator!", "error")
end)
