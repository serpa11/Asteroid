# Asteroid

Asteroid is a MobileGestalt tweak app for iOS, rebuilt on the latest [WorkTweaks](https://github.com/adnan120hz/WorkTweaks) foundation by Adnan. It uses the `worse_query` sandbox escape to apply MobileGestalt tweaks on-device, with backup/restore, and keeps the Asteroid icon and identity.

## Highlights

- **Siri AI Cache Patch (line 104)** - does the real Filza line-104 CacheData edit in-app: finds the 51-byte CacheData slot (guide line 104 / chunk 97 first, then scans every byte offset for the pattern on any iOS version), flips the byte at offset 21 (`0x00` -> `0x02`), and refuses to write when the pattern is missing or ambiguous.
- **MobileGestalt tweaks** - Dynamic Island, AOD, Apple Intelligence / Siri AI, Stage Manager, Charge Limit, Action Button, Camera Control, iPadOS mode, device spoofing, and more, with per-key backup and restore.
- **Airlift & pairing** - on-device pairing flow and Airlift utilities (where supported).
- **App Data / Cache / PosterBoard / Deploy** - the WorkTweaks utility suite, rebranded as Asteroid.
- **Backups** - original backup, after-apply snapshots, and manual snapshots with whole/per-tweak/per-key restore.

## Build

Pushes to `main` build unsigned IPAs in GitHub Actions (`build and release` workflow) and publish them to the `development` pre-release.

## Credits / License

Asteroid is based on [WorkTweaks](https://github.com/adnan120hz/WorkTweaks) by Adnan (@adnan120hz) and the upstream projects it credits (worse_query / ForceQuit OS, mond, Nugget, Pocket Poster, and others).  
WorkTweaks/derived code is distributed under **AGPL-3.0** - see [LICENSE](LICENSE).
