#!/bin/bash

# One-time prep
cp -p ~/.gitconfig.bak ~/.gitconfig
cd /home/josborne/code/demos/gitsign/repos && \
    git clone https://github.com/chainguard-dev/source-integrity-demo && \
    cd source-integrity-demo/ && clear
git branch
git checkout -b enforce-gitsign-branch

# Demo lack of GitHub verification - Dan Impersonation
# if not already on enforce-gitsign-branch use: git push --set-upstream origin enforce-gitsign-branch

git branch
cat dan-gitconfig
cp -p dan-gitconfig ~/.gitconfig
date >> date.out && git add date.out && \
    git commit -m 'adding date to date.out in enforce-gitsign-branch'

git push --set-upstream origin enforce-gitsign-branch && \
    xdg-open "https://github.com/chainguard-dev/source-integrity-demo/pull/new/enforce-gitsign-branch"

# Demo Enforce Accepted
# Install gitsign for the repo
# Note: It's important to restore the gitconfig here for the demo or it may confuse the customer
# Right now Enforce for GitHub does not care at all about your gitconfig only the signature, so the customer may get
# confused when you get a PR accepted because it's been signed even though the commits are false showing up as Dan still

cp -p ~/.gitconfig.bak ~/.gitconfig

# Install gitsign - this install the gitsign binary is in your path - https://github.com/sigstore/gitsign
# One-time setup for this repo
git config --local commit.gpgsign true  # Sign all commits
git config --local gpg.x509.program gitsign  # Use Gitsign for signing
git config --local gpg.format x509  # Gitsign expects x509 args
git config --local tag.gpgsign true  # Sign all tags
git config gitsign.matchCommitter true # Detect (earlier than PR) that you didn't sign with the correct browser window (OIDC) - enabling this will warn you when you commit

# Demo GitHub GPG Key for inline changes - (Enforce blocked)
# Browser update README.md in a new PR
# Uncomment kms in .source.yaml - https://github.com/web-flow.gpg
# # Browser update README.md in a new PR

# Cleanup 
cp -p ~/.gitconfig.bak ~/.gitconfig
git checkout main
# If it's local use: git branch -d enforce-gitsign-branch
git push origin -d enforce-gitsign-branch
# Comment out GitHub kms key - https://github.com/chainguard-dev/source-integrity-demo/blob/main/.chainguard/source.yaml
cd /home/josborne/code/demos/gitsign/repos && rm -rf /home/josborne/code/demos/gitsign/repos/source-integrity-demo

# chainctl policies create --group $DEMO_GROUP -f policies/signed-build-system.yaml
# chainctl policies create --group $DEMO_GROUP -f policies/vuln-critical-sarif-cve.yaml

# chainctl policy delete -y $(chainctl policy list -o json | jq -r '[.items[] | select(.name == "vuln-critical-sarif-cve")][0].id')
# chainctl policy delete -y $(chainctl policy list -o json | jq -r '[.items[] | select(.name == "signed-build-system")][0].id')

# Everything below here is a RIP
# # Working example
# # Show verify-gitsign
# xdg-open https://console.enforce.dev/policies
# # Grab subject.digest.sha256
# xdg-open "https://github.com/chainguard-dev/python-bandit-cip/pkgs/container/python-bandit-cip/versions" & xdg-open "https://rekor.tlog.dev/?logIndex=3476921"
# kubectl run git-signed --image=ghcr.io/chainguard-dev/python-bandit-cip@sha256:f43861382901bf6bd2082e078d02ec8583cdf8c753d023d56b5536f9e074533d

# # Broken example
# # Grab GitHub Workflow SHA: - 30bf0ae
# xdg-open "https://github.com/chainguard-dev/python-bandit-cip/commits/main" & xdg-open "https://rekor.tlog.dev/?logIndex=3477586"
# # Browse the repo at that point in time
# cosign verify-attestation --type=custom ghcr.io/chainguard-dev/python-bandit-cip@sha256:9e73a955b04812366cf375790631d553c7ad32bda13cc5467721a9c74a019b3c | jq -r .payload | base64 -d | jq 
# kubectl run git-unsigned --image=ghcr.io/chainguard-dev/python-bandit-cip@sha256:9e73a955b04812366cf375790631d553c7ad32bda13cc5467721a9c74a019b3c
# source /home/josborne/code/chainguard/chainguard-dev/gke-demo/highlight/highlight-record-list-gitsign.env && \
#     chainctl cluster records list $(kubectl get ns gulfstream -ojson | jq -r .metadata.uid) | head -15 | highlight
