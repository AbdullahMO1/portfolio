# Clarification Report — Senior Flutter Portfolio

**Based on**: `implementation_plan.md` and `task.md`
**Status**: Pre-implementation clarification of ambiguous areas.

---

## C1 — Resume Data Schema (GitHub Gist)

**Question**: What fields should `resume.json` contain?

**Proposed schema** (to validate before code generation):

```json
{
  "meta": { "name": "string", "tagline": "string", "email": "string", "github": "url", "linkedin": "url", "location": "string" },
  "about": "markdown string",
  "skills": [ { "category": "string", "items": ["string"] } ],
  "experience": [
    { "company": "string", "role": "string", "period": "string", "location": "string", "highlights": ["markdown string"] }
  ],
  "projects": [
    { "id": "slug", "title": "string", "description": "markdown string", "tech": ["string"], "github": "url?", "demo": "url?", "imageUrl": "url?" }
  ],
  "education": [ { "institution": "string", "degree": "string", "year": "string" } ],
  "certifications": [ { "title": "string", "issuer": "string", "year": "string" } ]
}
```

**Decision needed**: Confirm or amend the schema before `Freezed` model generation.

---

## C2 — Routing Structure

**Proposed deep-link routes** for `go_router`:

| Path | Shell section |
|---|---|
| `/` | Home / Hero |
| `/about` | About Me |
| `/skills` | Skills Grid |
| `/experience` | Timeline |
| `/projects` | Projects Grid |
| `/projects/:id` | Project Detail |
| `/contact` | Contact |

**Decision needed**: Are all these sections needed? Should `/contact` include a form with EmailJS, or just social links?

---

## C3 — Interactive Background: Shader Type

Two viable approaches (both impressive):

| Option | Technique | Impression |
|---|---|---|
| **A. Node Particle Network** | `CustomPainter` (Dart-drawn circles + lines) | More Dart control, easier to debug |
| **B. GLSL Fragment Shader** | `.frag` file + `FragmentShader` API | True GPU path, highest visual impact |

**Recommendation**: Option B — GLSL Fragment Shader for the hero section, Option A for secondary sections to keep code diverse.

**Decision needed**: Approve this split, or go all-in on one?

---

## C4 — Navigation Style (Desktop vs. Mobile)

| Screen | Navigation Type |
|---|---|
| Desktop / Wide (≥1200px) | Persistent side `NavigationRail` |
| Tablet (600px–1199px) | Collapsible side drawer |
| Mobile (<600px) | Bottom `NavigationBar` |

**Decision needed**: Confirm this breakpoint strategy.

---

## C5 — Theme Seed Color & Branding

Material 3 dynamic color requires a **seed color** to generate the full palette.

**Decision needed**: What is your preferred primary brand color? (e.g., a specific hex value, or a general direction like "deep indigo", "electric cyan", "emerald green").

---

## C6 — Deployment Target

| Option | Effort | Custom Domain |
|---|---|---|
| GitHub Pages | Low — free, automated via Actions | Possible via CNAME |
| Firebase Hosting | Medium — requires Firebase project setup | Yes |
| Vercel | Low — drag and drop or CLI | Yes |

**Recommendation**: GitHub Pages since the source is already on GitHub and the CI/CD plan uses GitHub Actions.

**Decision needed**: Confirm GitHub Pages as the deployment target.

---

## Summary of Decisions Needed Before Implementation

1. Confirm or amend `resume.json` schema (C1)
2. Confirm route structure + contact style (C2)
3. Shader split approval (C3)
4. Navigation breakpoints (C4)
5. Brand seed color / palette direction (C5)
6. Deployment target (C6)
