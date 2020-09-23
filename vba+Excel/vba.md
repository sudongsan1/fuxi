```vbscript
Private Sub anniu_Click()
Range("A1").Value = "Hello,VBA"
End Sub

Private Sub CommandButton2_Click()
Paths = ThisWorkbook.Path & "\"
Shell "explorer.exe " & Paths, vbNormalFocus
End Sub

Private Sub 执行hh脚本_Click()
hh = ThisWorkbook.Path & "\hh.bat"
Shell hh, vbNormalFocus
End Sub


```

