from __future__ import annotations

from wechat_agent_poc.config import AppConfig, isoformat
from wechat_agent_poc.models import SCHEMA_VERSION, Event, event_key
from wechat_agent_poc.store import Store


class MockReader:
    def __init__(self, events: list[Event] | None = None):
        self.queue: list[Event] = list(events or [])
        self.calls = 0

    def push(self, event: Event) -> None:
        self.queue.append(event)

    def read_new_messages(self, binding=None, checkpoint_store: Store | None = None) -> list[Event]:
        self.calls += 1
        batch = list(self.queue)
        self.queue.clear()
        if checkpoint_store is not None and batch:
            checkpoint_store.ingest(batch, [])
        return batch


def make_event(
    *,
    account: str = "test-wechat-a",
    conversation: str,
    shard: str = "message_0",
    table: str = "Msg_demo",
    message_id: int | None,
    text: str | None,
    is_self: str = "false",
    historical: bool = False,
    identity: str = "resolved",
    sender: str | None = "member-a",
    source_time: int = 1_800_000_000,
    parse_status: str = "ok",
    halt_reason: str | None = None,
    runtime_id: str | None = None,
) -> Event:
    return Event(
        schema_version=SCHEMA_VERSION,
        event_key=event_key(account, shard, table, message_id, conversation),
        account_alias=account,
        conversation_key=conversation,
        source_shard=shard,
        source_table=table,
        source_message_id=message_id,
        sender_key=sender,
        is_self=is_self,  # type: ignore[arg-type]
        source_time=source_time,
        observed_at=isoformat(),
        text=text,
        evidence_ref=f"{shard}:{table}:{message_id}",
        identity_status=identity,  # type: ignore[arg-type]
        is_historical=historical,
        parse_status=parse_status,  # type: ignore[arg-type]
        halt_reason=halt_reason,
        runtime_id=runtime_id,
    )
