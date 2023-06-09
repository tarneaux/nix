{ username, hostname, ... }:
{
  services.openssh.enable = true;
  networking.hostName = hostname;
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUDydvJVKO406UxzJv45dZOj71mNnu5Cb0gWqeU0CBENyfjSA8zD6yPb/MOtR7Ee2PtPNummts5PmKzi4Gxzf54pxf5RtjrOpy7dhAhrm3O43boKSxUfnr/s76CAUXlzSul5a4rtH7sZVHg/IEoa5UdxXaa9mj43Wcn9NXyXLVpDG2RVFa7Zz1+n9T+9VoWcedpDxxayogaYS9C2JxTAiKEHT3IzzA7e2Ed/PrjIpzpI2D3YMnzvmy9t1hsWCwy6ql7oQyL3AtZ62+aKUp2FoZlzqudIZ+lu5Dw+0xz+uzgXyf9KrJndmAvqULeWTBheYX3fMUcnqBQCXvfxvyoebCpOERWmMoFWy4oI02kZvzdCvzjBdXszhTIwXjhyha8QJY1tBTId3MHbEGWGe1UePCRMm2gKble+j671NM/ZCQodgMyEPbCFBE3euPb1WnQoi4NPmTt7SON/e4dbuKVbrf5GT0Wmej93jlZalrg71zf6s7rTrkFtqyAEpoP48OVKE= max@desky"
  ];
}
