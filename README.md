# `code/`
Repo for containing all of my scripts or snippets that can be useful in any language.


| Folder Name  | Description          |
|--------------|----------------------|
| `kubernetes` | Kubernetes Resources |
| `typescript` | TypeScript Resources |


# SSH Updater Curl Pipe into Sudo
In order to directly update a linux system with an affected CVE for SSH you can use the following dangerous `curl pipe

> [!WARNING]
> This is dangerous and should be used with care

```bash
sudo curl https://raw.githubusercontent.com/txj-xyz/code/main/bash/ssh-updater.sh | sudo bash
```
