# Enforcing source code integrity through gitsign

## Install

Install [gitsign:](https://github.com/sigstore/gitsign)
```
go install github.com/sigstore/gitsign@latest
```

### Prep (one-time only)
```
git config --local commit.gpgsign true  # Sign all commits
git config --local gpg.x509.program gitsign  # Use Gitsign for signing
git config --local gpg.format x509  # Gitsign expects x509 args
git config --local tag.gpgsign true  # Sign all tags
```

### Demo  (Enforce gitsign)
```
$ git branch
$ git checkout -b enforce-gitsign-branch
$ date >> date.out && git add date.out && git commit -m 'adding date to date.out in enforce-gitsign-branch'
$ git push --set-upstream origin enforce-gitsign-branch
```

## Cleanup

```
git checkout main
git push -d origin enforce-gitsign-branch
git branch -D enforce-gitsign-branch
```
