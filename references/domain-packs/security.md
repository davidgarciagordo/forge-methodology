# Forge — Security Pack

> Domain pack for Forge methodology. Instantiates the universal 7-step loop for security assessments, threat modeling, and security-focused work.
> Core references: [the-loop.md](../the-loop.md) · [grill.md](../grill.md) · [verification.md](../verification.md)

---

## Grill Lenses for Security

| Lens | Perspective | Focus |
|------|------------|-------|
| **Attacker** | System view | Exploitable paths, privilege escalation opportunities, data exposure, authentication bypass, injection vectors, abuse of intended functionality. What would an adversary try first? |
| **Defender / Incident Responder** | Human reality | Detection coverage, alerting, containment options, blast radius if a breach occurs, recovery time and data loss exposure. What does the response look like when this fails? |
| **Compliance / Audit** | Technical depth | Regulatory obligations (GDPR, SOC 2, HIPAA, PCI-DSS, or applicable standard), evidence requirements, audit trail completeness, what auditors will look for and what will fail a certification. |

---

## Definition of Done — Security

Security work is done when **all** of the following are true:

- [ ] All identified threat vectors have a documented control (mitigate, accept, or transfer — not ignore)
- [ ] Adversarial review (penetration test, red team exercise, or structured threat model review) completed and findings addressed
- [ ] Applicable compliance requirements verified and evidence collected
- [ ] No secrets, credentials, or sensitive data in version control or logs
- [ ] Authentication and authorization verified on all access paths
- [ ] Input validation present at all system boundaries
- [ ] Rate limiting on all externally reachable endpoints
- [ ] Audit trail covers all security-relevant events (access, changes, failures)
- [ ] Incident response runbook updated if the change affects the attack surface

---

## What to Verify

### OWASP Top 10 (minimum baseline)
- Injection (SQL, command, template, LDAP) — parameterized queries and sanitization at boundaries
- Broken authentication — session management, credential storage, MFA
- Sensitive data exposure — data at rest and in transit, PII handling, logging hygiene
- Security misconfiguration — default credentials, unnecessary features enabled, error verbosity
- Insecure dependencies — known CVEs in third-party packages

### Access control
- Authentication required on every non-public endpoint
- Authorization checked per resource, not just per route
- Privilege escalation not possible through parameter manipulation
- Multi-tenant isolation verified (one tenant cannot access another's data)

### Secrets and credentials
- No hardcoded secrets in source code, configuration files, or version history
- Secrets managed through a secrets manager or environment variables
- Rotation procedure exists and is documented

### Evidence for compliance
- Audit logs capture: who accessed what, when, from where, and what changed
- Logs are tamper-evident and retained per applicable requirements
- Data processing activities documented per applicable regulation

---

## Security Principles

- **Validate at every boundary.** Trust nothing that crosses a trust boundary: user input, external APIs, inter-service calls, file uploads.
- **Fail secure.** When a security check cannot be completed, deny — do not default to permissive.
- **Least privilege.** Every component, service account, and user role has only the permissions it needs for its specific function.
- **Assume breach.** Design detection and containment assuming the perimeter will eventually be breached.
- **Security checks are never silenced.** If a security test fails, fix the code — do not disable the test.
