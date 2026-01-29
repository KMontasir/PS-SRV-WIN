### FONCTION #############################################################################


function f_choix_info {

    Write-Host "`n*** MENU INFORMATIONS SERVEUR :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Informations generales
    `n2 - Informations reseaux
    `n3 - Services installes
    `n4 - Utilisateurs et groupes locaux
    `n5 - Quitter `n"

    $choix = Read-Host "`n*** Quelle information souhaitez-vous connaitre ?"

    switch ($choix) {

        "1" {
            Write-Output "`n Nom de la machine et domaine : `n"
            Get-ComputerInfo -Property CsDNSHostName, CsDomain, CsUserName

            Write-Output "`n Informations OS : `n"
            Get-ComputerInfo -Property WindowsInstallDateFromRegistry, WindowsProductName, OsArchitecture, WindowsVersion, WindowsSystemRoot

            Write-Output "`n Informations disques : `n"
            Get-Disk | Select-Object Number, FriendlyName, OperationalStatus, PartitionStyle, Size
            Get-Partition | Select-Object DiskNumber, PartitionNumber, DriveLetter, Size

            f_choix_info
        }

        "2" {
            Write-Output "`n Informations reseaux : `n"
            Get-NetAdapter | Format-List Name, InterfaceIndex, MacAddress, MediaConnectionState, LinkSpeed
            Get-WmiObject Win32_NetworkAdapterConfiguration -Filter IPEnabled=True |
                Select-Object MACAddress, IPAddress, DHCP*

            f_choix_info
        }

        "3" {
            Write-Output "`n Services installes : `n"
            Get-WindowsFeature | Where-Object Installed |
                Select-Object Name, Description

            f_choix_info
        }

        "4" {
            Write-Output "`n Informations utilisateurs : `n"
            Get-LocalUser |
                Select-Object Name, ObjectClass, SID, PasswordRequired, Enabled, PasswordChangeableDate, PasswordExpires

            Write-Output "`n Informations groupes : `n"
            Get-LocalGroup |
                Select-Object Name, ObjectClass, SID, Description

            f_choix_info
        }

        "5" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
            f_choix_info
        }
    }
}



### PROGRAMME PRINCIPAL #################################################################


f_choix_info