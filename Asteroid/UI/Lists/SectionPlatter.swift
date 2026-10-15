from pathlib import Path
for p,n in [
(r"C:\Users\name\Documents\Default Project\Asteroid\Asteroid\UI\Lists\SectionPlatter.swift",0.38),
(r"C:\Users\name\Documents\Default Project\Asteroid\Asteroid\UI\Lists\TerminalPlatter.swift",0.45)]:
    path=Path(p)
    s=path.read_text()
    s=s.replace("appAccentColor().opacity(0.38)", "(UserDefaults.standard.bool(forKey: \"glassBorders\") ? appAccentColor().opacity(0.38) : .clear)")
    s=s.replace("appAccentColor().opacity(0.45)", "(UserDefaults.standard.bool(forKey: \"glassBorders\") ? appAccentColor().opacity(0.45) : .clear)")
    path.write_text(s)
print("done")
