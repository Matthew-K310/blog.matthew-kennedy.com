+++
title = "Setting up a file share for media links"
author = ["Matthew Kennedy"]
date = 2025-10-10T17:05:17Z
draft = true
+++

## Introduction {#introduction}

While I was hanging out in the vt100 chat room (see [https://xn--gckvb8fzb.com/contact/](https://xn--gckvb8fzb.com/contact/)), a friend of mine shared an image link with a domain I hadn’t seen before.

Curious, I asked about it - and he explained that he has a file share set up that’s just an SFTP server made accessible through **Caddy**.

As someone who enjoys self-hosting as much as possible, I decided to set up something similar myself.

However, my ISP is **Spectrum**, and they aren’t exactly friendly about unblocking ports (HTTP, HTTPS, SSH, etc.), so I had to find a workaround.


## System Setup {#system-setup}

I already have an **NGINX Proxy Manager (NPM)** instance running inside an **LXC container** on my **Proxmox** server, which runs on a ****Dell OptiPlex 3020 SFF**** with an **Intel i5-4590** and **8 GB of RAM**.


## Configuring Caddy {#configuring-caddy}

I set up **Caddy** to host the root directory of my SFTP server on port 80 and pointed **NPM** to the local IP address at that port.



Then I added my existing SSL certificate within **NPM**.


## <span class="org-todo todo TODO">TODO</span> Add File Config Blocks {#add-file-config-blocks}

```cfg
# Example Caddyfile configuration
:TODO: add example here
```

```cfg
# Example SSH/SFTP configuration
:TODO: add example here
```


## Testing the Setup {#testing-the-setup}

Once everything was configured, I just needed to upload something to the server to test access.

{{< figure src="other/assets/20251010/20251010_172845.png" alt="Test file screenshot" width="80%" >}}

Now, when I navigate to the IP address or domain in my browser, I can copy the link to the file and share it with whoever I please.

<https://files.matthewcloud.us/very_important_file.mp4>


## Performance and Future Plans {#performance-and-future-plans}

My server doesn’t have a GPU, which means that video transcoding takes quite a while. I hope to upgrade the hardware in the future — but that’s a topic for another time.


## Conclusion {#conclusion}

Thank you for indulging me,  and I’ll see you in the next one.

<style>.org-center { margin-left: auto; margin-right: auto; text-align: center; }</style>

<div class="org-center">

**God bless,**
**Matthew**

</div>
