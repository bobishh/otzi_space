# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OtziSpace.Repo.insert!(%OtziSpace.SomeModel{})
alias OtziSpace.Role
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
for role <- ~w(master client) do
  OtziSpace.Repo.insert!( %Role{name: role} )
end
