Build a docker image to run HashiCorp Vault for the dockerized UH Groupings 
project.

This is purely experimental at this point.

The design goal is to implement a .vault in the developer home directory to 
persistently store the Grouper API password used by the UH Groupings API.

When the developer attempts to run the containerized UH Groupings project 
the vault will supply the password.
