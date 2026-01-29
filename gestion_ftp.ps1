### FONCTION #############################################################################

function f_choix_ftp {

    Import-Module WebAdministration

    Write-Host "`n*** MENU GESTION FTP :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les sites (WEB et FTP)
    `n2 - Creer un site FTP (Necessite un repertoire partage et un port ouvert)
    `n3 - Autoriser l'acces sur un site FTP
    `n4 - Quitter `n"

    $choix = Read-Host "`n*** Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            Get-ItemProperty "IIS:\Sites\*"
        }

        "2" {
            $nom_ftp  = Read-Host "`n*** Nom du site FTP ? (ex: FTPSite)"
            $ip_ftp   = Read-Host "`n*** Adresse IP du site FTP ? (ex: 192.168.1.200)"
            $port_ftp = Read-Host "`n*** Port d'ecoute ? (ex: 21)"

            New-WebFtpSite -Name $nom_ftp -IPAddress $ip_ftp -Port $port_ftp

            $chemin_ftp = Read-Host "`n*** Chemin physique du site FTP ? (ex: E:\WebSite\FTPSite)"
            Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name physicalPath -Value $chemin_ftp

            $choix_ssl = Read-Host "`n*** Configurer le SSL ? (O/N)"

            if ($choix_ssl -match "^[Oo]$") {

                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.ssl.controlChannelPolicy -Value "SslRequire"
                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.ssl.dataChannelPolicy -Value "SslRequire"

                $ip_dns   = Read-Host "`n*** IP/DNS du certificat ?"
                $annees   = Read-Host "`n*** Duree du certificat (annees) ?"

                New-SelfSignedCertificate `
                    -DnsName $ip_dns `
                    -KeyAlgorithm RSA `
                    -KeyLength 2048 `
                    -CertStoreLocation "Cert:\LocalMachine\My" `
                    -NotAfter (Get-Date).AddYears($annees)

                Get-ChildItem Cert:\LocalMachine\My

                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.ssl.serverCertStoreName -Value "My"

                $hash_cert = Read-Host "`n*** Empreinte du certificat ?"
                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.ssl.serverCertHash -Value $hash_cert

                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.authentication.anonymousAuthentication.enabled -Value $true

                $choix_port = Read-Host "`n*** Autoriser le port $port_ftp dans le firewall ? (O/N)"

                if ($choix_port -match "^[Oo]$") {
                    New-NetFirewallRule `
                        -Name "00 Autoriser FTP $port_ftp" `
                        -DisplayName "00 Autoriser FTP $port_ftp" `
                        -Direction Inbound `
                        -Protocol TCP `
                        -LocalPort $port_ftp `
                        -Action Allow
                }
            }
            else {
                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.ssl.controlChannelPolicy -Value "SslAllow"
                Set-ItemProperty "IIS:\Sites\$nom_ftp" -Name ftpServer.security.ssl.dataChannelPolicy -Value "SslAllow"
            }
        }

        "3" {
            Get-ItemProperty "IIS:\Sites\*"
            $nom_ftp = Read-Host "`n*** Nom du site FTP ?"

            Write-Output "
            `n1 - Tout le monde
            `n2 - Un utilisateur
            `n3 - Un groupe"

            $choix_acces = Read-Host "`n*** Qui aura acces ?"

            switch ($choix_acces) {

                "1" {
                    Add-WebConfiguration "/system.ftpServer/security/authorization" `
                        -Location $nom_ftp -PSPath IIS:\ `
                        -Value @{ accessType="Allow"; roles="Tout le monde"; permissions="Read,Write" }
                }

                "2" {
                    $user = Read-Host "`n*** Nom de l'utilisateur ?"
                    Add-WebConfiguration "/system.ftpServer/security/authorization" `
                        -Location $nom_ftp -PSPath IIS:\ `
                        -Value @{ accessType="Allow"; roles=$user; permissions="Read,Write" }

                    Set-ItemProperty "IIS:\Sites\$nom_ftp" `
                        -Name ftpServer.security.authentication.basicAuthentication.enabled `
                        -Value $true
                }

                "3" {
                    $group = Read-Host "`n*** Nom du groupe ?"
                    Add-WebConfiguration "/system.ftpServer/security/authorization" `
                        -Location $nom_ftp -PSPath IIS:\ `
                        -Value @{ accessType="Allow"; roles=$group; permissions="Read,Write" }

                    Set-ItemProperty "IIS:\Sites\$nom_ftp" `
                        -Name ftpServer.security.authentication.basicAuthentication.enabled `
                        -Value $true
                }

                default {
                    Write-Warning "Erreur de choix !"
                }
            }
        }

        "4" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    f_choix_ftp
}


### PROGRAMME PRINCIPAL #################################################################


f_choix_ftp