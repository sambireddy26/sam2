Param 
(
	[string]$Workspace,
	[string]$BBUserName,
	[string]$BBPassword,
	[string]$BaseBranchName

)


try  {

    
	Write-Host Workspace $Workspace
	Write-Host BBUserName $BBUserName
	Write-Host BBPassword $BBPassword
	Write-Host BaseBranchName $BaseBranchName
	
        $RepositoryNamesitoryList='sam1', 'sam2'

 	Foreach ($RepositoryName in $RepositoryNamesitoryList)
	{

		Write-host "`n====== Repository Name:" $RepositoryName
		
		######### Clone Workspace
	
			Write-host "--------- Clone Repository:" $RepositoryName
			cd $Workspace
	Write-Host " git clone -b $BaseBranchName https://$BBUserName':'$EncodedPassword@github.com/sambireddy26/$RepositoryName.git::::"
            git clone -b $BaseBranchName https://$BBUserName':'$EncodedPassword@github.com/sambireddy26/$RepositoryName.git

            #$command = "git clone https://"+$BBUserName+":"+$BBPassword+"@bitbucket.org/automationanywhere/"+$RepositoryName+".git"
	    #iex $command
       Write-Host $LASTEXITCODE
	     if ($LASTEXITCODE -ne 0)
           {
             write-host ************* LASTEXITCODE $LASTEXITCODE
              write-host $LASTEXITCODE
                Exit 1
            }

		}
		}
	

		catch
		{
		        Write-Host ":::::::::::::catch block::::::::::::::::"
			Write-Host ************* $_.Exception.Message 
			Exit 1
		}

