### FONCTION #############################################################################

function f_choix_install {

    Write-Host "`n*** MENU INSTALLATION ROLE :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Routage NAT
    `n2 - DNS (Le serveur redemarrera)
    `n3 - AD-DS
    `n4 - DHCP
    `n5 - IIS
    `n6 - FTP
    `n7 - DFS
    `n8 - WDS
    `n9 - Quitter `n"

    $choix = Read-Host "`n*** Quel service voulez-vous installer ?"

    switch ($choix) {

        "1" {
            Install-WindowsFeature RemoteAccess
            Install-WindowsFeature DirectAccess-VPN -IncludeManagementTools
            Install-WindowsFeature Routing -IncludeManagementTools
        }

        "2" {
            Install-WindowsFeature DNS -IncludeManagementTools
            Restart-Computer
        }

        "3" {
            $domaine = Read-Host "Entrer le nom de domaine a creer (ex: domaine.local)"
            $netBios = Read-Host "Entrer le nom NetBIOS (ex: DOMAINE)"

            Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
            Install-ADDSForest -DomainName $domaine -DomainNetBiosName $netBios
            Restart-Computer
        }

        "4" {
            $if_domaine = Read-Host "Autoriser le serveur DHCP sur un controleur de domaine ? (O/N)"

            if ($if_domaine -match "^[Oo]$") {
                $dc = Read-Host "Entrer le nom du controleur de domaine (ex: dc.domaine.local)"
                Install-WindowsFeature DHCP -IncludeManagementTools
                Add-DHCPServerInDC -DNSName $dc
                Add-DhcpServerSecurityGroup
            }
            elseif ($if_domaine -match "^[Nn]$") {
                Install-WindowsFeature DHCP -IncludeManagementTools
            }
            else {
                Write-Warning "Erreur de choix !"
            }
        }

        "5" {
            Install-WindowsFeature Web-Server -IncludeManagementTools
        }

        "6" {
            Install-WindowsFeature Web-Server -IncludeManagementTools
            Install-WindowsFeature Web-FTP-Server -IncludeManagementTools
        }

        "7" {
            Install-WindowsFeature FS-DFS-Replication
        }

        "8" {
            Install-WindowsFeature WDS
        }

        "9" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    f_choix_install
}

### PROGRAMME PRINCIPAL #################################################################


f_choix_install