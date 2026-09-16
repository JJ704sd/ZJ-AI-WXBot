"""Prepare the user-supplied 861 Windows archive without executing it."""
from pathlib import Path, PurePosixPath
import hashlib
import json
import re
import secrets
import sys
import zipfile

EXPECTED = '4500ab14ac22b71146705ed2dc0046af4ee6ed555a617ba99430e1e1546d9430'
root = Path(__file__).resolve().parents[1]
archive = Path(sys.argv[1]).resolve()
target = root / '.local' / 'pad-legacy-861'
if target.exists():
    raise SystemExit('Refusing to overwrite existing local configuration: ' + str(target))
with archive.open('rb') as stream:
    digest = hashlib.file_digest(stream, 'sha256').hexdigest()
if digest != EXPECTED:
    raise SystemExit('Archive digest mismatch; no files extracted')
with zipfile.ZipFile(archive) as z:
    for entry in z.infolist():
        path = PurePosixPath(entry.filename.replace('\\', '/'))
        if path.is_absolute() or '..' in path.parts or ':' in entry.filename:
            raise SystemExit('Unsafe archive path')
        if (entry.external_attr >> 16) & 0o170000 == 0o120000:
            raise SystemExit('Archive symlinks are not allowed')
    if sum(i.file_size for i in z.infolist()) > 200_000_000:
        raise SystemExit('Unexpected archive expansion size')
    bad = z.testzip()
    if bad:
        raise SystemExit('CRC failure: ' + bad)
    runtime = target / 'runtime'
    runtime.mkdir(parents=True)
    z.extractall(runtime)

admin, redis, mysql, mysql_root = (secrets.token_hex(32) for _ in range(4))
env = (runtime / '.env').read_text(encoding='utf-8-sig')
updates = {
    'DEBUG': 'false', 'HOST': '127.0.0.1', 'PORT': '1238',
    'MCP_PORT': '0', 'GH_WXID': '', 'ADMIN_KEY': admin,
    'REDIS_HOST': '127.0.0.1', 'REDIS_PORT': '16379', 'REDIS_DB': '1', 'REDIS_PASS': redis,
    'MYSQL_CONNECT_STR': f'pad861:{mysql}@tcp(127.0.0.1:13306)/pad861?charset=utf8mb4&parseTime=true&loc=Local',
    'MYSQL_ROOT_PASSWORD': mysql_root, 'MYSQL_DATABASE': 'pad861',
    'MYSQL_USER': 'pad861', 'MYSQL_PASSWORD': mysql,
    'TZ': 'Asia/Shanghai', 'WEB_DOMAIN': '', 'WEB_TASK_NAME': '', 'WEB_TASK_APP_NUMBER': '',
    'ROCKET_MQ_ENABLED': 'false', 'RABBIT_MQ_ENABLED': 'false', 'KAFKA_ENABLED': 'false',
    'ROCKET_ACCESS_KEY': '', 'ROCKET_SECRET_KEY': '', 'RABBIT_MQ_URL': '',
    'KAFKA_URL': '', 'KAFKA_USERNAME': '', 'KAFKA_PASSWORD': '',
    'CLUSTER_NAME': '', 'ZK_ADDR': '', 'ETCD_ADDR': '',
    'TASK_RETRY_COUNT': '0',
}
for key, value in updates.items():
    pattern = rf'(?m)^{re.escape(key)}=.*$'
    if not re.search(pattern, env):
        raise SystemExit('Missing package configuration key: ' + key)
    env = re.sub(pattern, lambda _: key + '=' + value, env)
(runtime / '.env').write_text(env, encoding='utf-8')
(target / '.env.dependencies').write_text(
    f'PAD_REDIS_PASSWORD={redis}\nPAD_MYSQL_PASSWORD={mysql}\nPAD_MYSQL_ROOT_PASSWORD={mysql_root}\n',
    encoding='utf-8')
(target / 'compose.dependencies.yaml').write_text('''name: pad-legacy-861
services:
  redis:
    image: redis:7-alpine
    restart: "no"
    ports: ["127.0.0.1:16379:6379"]
    environment:
      REDIS_PASSWORD: ${PAD_REDIS_PASSWORD:?required}
    command: ["sh", "-c", 'exec redis-server --appendonly yes --requirepass "$$REDIS_PASSWORD"']
    volumes: ["redis_data:/data"]
    healthcheck:
      test: ["CMD-SHELL", 'REDISCLI_AUTH="$$REDIS_PASSWORD" redis-cli ping | grep -q PONG']
      interval: 5s
      timeout: 3s
      retries: 20
  mysql:
    image: mysql:8.0
    restart: "no"
    ports: ["127.0.0.1:13306:3306"]
    environment:
      MYSQL_ROOT_PASSWORD: ${PAD_MYSQL_ROOT_PASSWORD:?required}
      MYSQL_DATABASE: pad861
      MYSQL_USER: pad861
      MYSQL_PASSWORD: ${PAD_MYSQL_PASSWORD:?required}
    volumes: ["mysql_data:/var/lib/mysql"]
    healthcheck:
      test: ["CMD-SHELL", 'MYSQL_PWD="$$MYSQL_PASSWORD" mysql -h 127.0.0.1 -u pad861 -D pad861 -e "SELECT 1"']
      interval: 5s
      timeout: 5s
      retries: 30
volumes:
  redis_data:
  mysql_data:
''', encoding='utf-8')

profile = json.loads((root / 'pad-provider-profile.legacy.example.json').read_text(encoding='utf-8'))
exe = runtime / 'wechatpadpro-windows-amd64-vios18.61-861.exe'
swagger = runtime / 'static/swagger/swagger.json'
hashes = {}
for p in [exe, swagger, runtime / 'static/swagger/swagger.yml', runtime / 'version.txt']:
    hashes[p.relative_to(runtime).as_posix()] = hashlib.sha256(p.read_bytes()).hexdigest()
product = profile['product']
for key, value in {
    'build_id': 'ios18.61-861 / 20250822_153444',
    'binary_sha256_or_digest': 'sha256:' + hashes[exe.name],
    'docs_export_sha256': 'sha256:' + hashes['static/swagger/swagger.json'],
    'os': 'windows amd64 (package version.txt)',
    'observed_at': '2026-09-16 static file inspection only',
}.items():
    product[key] = {'status': 'observed', 'value': value, 'note': 'Local file bytes; not runtime validation'}
product['protocol_api_version'] = {'status': 'documented', 'value': 'Bundled Swagger 861: /message/SendTextMessage; /webhook/Config; query key. Effective route prefix unverified.'}
product['runtime_dependencies'] = {'status': 'documented', 'value': 'Bundled README: MySQL 8.0 + Redis 7; local dependencies not started'}
product['auth_form'] = {'status': 'documented', 'value': 'Bundled Swagger query parameter key; no MAX double-token mapping'}
product['config_summary'] = {'status': 'observed', 'value': 'Local prepared .env; runtime effects unverified'}
product['sample_refs'] = {'status': 'documented', 'value': 'Bundled Swagger, not callback captures'}
profile['note'] = 'User-supplied Windows legacy archive locally hashed. Bundled Swagger found but has malformed method/schema. P0 remains open; live not authorized by this config.'
profile['p0_closed'] = False
(target / 'provider-profile.json').write_text(json.dumps(profile, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
cfg = (root / 'config.pad.example.toml').read_text(encoding='utf-8')
cfg = cfg.replace('api_flavor = "MAX"', 'api_flavor = "legacy"').replace('pad-provider-profile.max.example.json', 'provider-profile.json')
cfg = cfg.replace('.local/pad-observe/', 'observation/').replace('.local/pad-agent/', 'agent/')
(target / 'config.pad.toml').write_text(cfg, encoding='utf-8')
manifest = {'archive': archive.name, 'archive_sha256': digest, 'hashes': hashes,
            'archive_crc': 'passed', 'gateway_started': False, 'dependencies_started': False,
            'p0_closed': False, 'runtime_config_verified': False}
(target / 'manifest.json').write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8')
print(json.dumps({'prepared_directory': str(target), **manifest}, indent=2))
