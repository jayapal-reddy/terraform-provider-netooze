package netooze

import (
	"context"

	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/netooze/terraform-provider-netooze/netooze/ssclient"
)

// Provider -
func Provider() *schema.Provider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"host": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("NETOOZE_HOST", nil),
			},
			"key": {
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("NETOOZE_KEY", nil),
			},
		},
		ResourcesMap: map[string]*schema.Resource{
			"netooze_server":           resourceServer(),
			"netooze_isolated_network": resourceNetwork(),
			"netooze_ssh":              resourceSSH(),
		},
		ConfigureContextFunc: providerConfigure,
	}
}

func providerConfigure(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
	key := d.Get("key").(string)
	host := d.Get("host").(string)

	var diags diag.Diagnostics

	c, err := ssclient.NewClient(key, host)
	if err != nil {
		diags = append(diags, diag.Diagnostic{
			Severity: diag.Error,
			Summary:  "Unable to create netooze client",
			Detail:   err.Error(), // "Unable to authenticate user for authenticated netooze client",
		})

		return nil, diags
	}

	return c, diags

}
