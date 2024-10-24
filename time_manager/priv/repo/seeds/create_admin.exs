# priv/repo/seeds/create_admin.exs

alias Timemanager.Repo
alias Timemanager.Accounts.User

# Définissez les informations de l'administrateur
admin_params = %{
  username: "admin",
  email: "admin@example.com",
  password: "admin_password_123",  # Assurez-vous d'utiliser un mot de passe fort en production
  role: "admin"
}

# Vérifiez si l'admin existe déjà
case Repo.get_by(User, email: admin_params.email) do
  nil ->
    # Créez l'administrateur s'il n'existe pas
    %User{}
    |> User.changeset(admin_params)
    |> Repo.insert!()
    IO.puts "Administrateur créé avec succès."

  _user ->
    IO.puts "L'administrateur existe déjà."
end

# Vérifiez que l'administrateur a été créé ou existe
admin = Repo.get_by!(User, email: admin_params.email)
IO.puts "Administrateur : #{admin.username}, Role : #{admin.role}"
