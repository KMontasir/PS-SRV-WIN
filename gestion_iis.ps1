### FONCTION #############################################################################

function f_choix_iis {

    Write-Host "`n*** MENU GESTION IIS :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Afficher les sites
    `n2 - Supprimer le site par defaut (Le serveur redemarrera)
    `n3 - Creer un site (Necessite un repertoire partage)
    `n4 - Configurer le SSL pour un site
    `n5 - Quitter `n"

    $choix = Read-Host "`n*** Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            Get-IISSite
        }

        "2" {
            Remove-IISSite -Name "Default Web Site" -WhatIf
        }

        "3" {
            $nom_site    = Read-Host "`n*** Quel sera le nom du site ? (ex: MonSiteWeb)"
            $chemin_site = Read-Host "`n*** Quel sera le chemin du site ? (ex: E:\Repertoire_Partage)"
            $port_site   = Read-Host "`n*** Quel sera le port d'ecoute du site ? (ex: 80)"

            New-IISSite -Name $nom_site -PhysicalPath $chemin_site -BindingInformation "*:${port_site}:"
            Start-IISSite -Name $nom_site

            Write-Output "Vous pouvez ajouter votre page web dans ${chemin_site}"
        }

        "4" {
            Get-IISSite

            $nom_site = Read-Host "`n*** Quel est le nom du site ? (ex: MonSiteWeb)"
            $nom_dns  = Read-Host "`n*** Quel est le nom DNS ? (ex: srv.domaine.local)"

            New-WebBinding -Name $nom_site -IPAddress * -Port 443 -Protocol https
            New-SelfSignedCertificate -CertStoreLocation "Cert:\LocalMachine\My" -DnsName $nom_dns

            $chemin_cert = "Cert:\LocalMachine\My"
            Write-Output "`n*** Certificats disponibles :"
            Get-ChildItem $chemin_cert

            $nom_cert = Read-Host "`n*** Empreinte du certificat a lier ?"
            Get-Item "${chemin_cert}\${nom_cert}" | New-Item "IIS:\SSLBindings\0.0.0.0!443"

            Write-Output "`n*** Acces HTTPS disponible (ex: https://IP:443)"
        }

        "5" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    f_choix_iis
}

### PROGRAMME PRINCIPAL #################################################################


f_choix_iis