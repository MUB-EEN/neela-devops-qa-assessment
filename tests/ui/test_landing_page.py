from playwright.sync_api import expect


def test_landing_page_branding(page, live_server):
    page.goto(f"{live_server}/")

    expect(page).to_have_title("MyTemplate")
    expect(page.locator("header .logo")).to_contain_text("MyTemplate")
    expect(page.get_by_role("heading", name="Batteries Included")).to_be_visible()
    expect(page.get_by_role("link", name="Demo").nth(1)).to_be_visible()
