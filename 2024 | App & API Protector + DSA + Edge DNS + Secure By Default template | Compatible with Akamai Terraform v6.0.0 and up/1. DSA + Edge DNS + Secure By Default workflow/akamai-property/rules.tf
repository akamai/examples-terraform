
data "akamai_property_rules_builder" "property_rule_default" {
  rules_v2024_02_12 {
    name      = "default"
    is_secure = false
    comments  = "The Default Rule template contains all the necessary and recommended features. Rules are evaluated from top to bottom and the last matching rule wins."
    behavior {
      origin {
        cache_key_hostname               = "REQUEST_HOST_HEADER"
        compress                         = true
        custom_valid_cn_values           = ["{{Origin Hostname}}", "{{Forward Host Header}}", ]
        enable_true_client_ip            = true
        forward_host_header              = "ORIGIN_HOSTNAME"
        hostname                         = var.origin_hostname
        http_port                        = 80
        https_port                       = 443
        ip_version                       = "IPV4"
        origin_certificate               = ""
        origin_certs_to_honor            = "STANDARD_CERTIFICATE_AUTHORITIES"
        origin_sni                       = true
        origin_type                      = "CUSTOMER"
        ports                            = ""
        standard_certificate_authorities = ["akamai-permissive", ]
        true_client_ip_client_setting    = false
        true_client_ip_header            = "True-Client-IP"
        verification_mode                = "CUSTOM"
      }
    }
    behavior {
      auto_domain_validation {
        autodv = ""
      }
    }
    children = [
      data.akamai_property_rules_builder.property_rule_augment_insights.json,
      data.akamai_property_rules_builder.property_rule_augment_insights_rule_accelerate_delivery.json,
      data.akamai_property_rules_builder.property_rule_augment_insights_rule_offload_origin.json,
      data.akamai_property_rules_builder.property_rule_augment_insights_rule_strengthen_security.json,
      data.akamai_property_rules_builder.property_rule_increase_availability.json,
      data.akamai_property_rules_builder.property_rule_minimize_payload.json,
      data.akamai_property_rules_builder.property_rule_redirects.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_augment_insights" {
  rules_v2024_02_12 {
    name                  = "Augment insights"
    comments              = "Control the settings related to monitoring and reporting. This gives you additional visibility into your traffic and audiences."
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_traffic_reporting.json,
      data.akamai_property_rules_builder.property_rule_m_pulse_rum.json,
      data.akamai_property_rules_builder.property_rule_geolocation.json,
      data.akamai_property_rules_builder.property_rule_log_delivery.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_augment_insights_rule_accelerate_delivery" {
  rules_v2024_02_12 {
    name                  = "Accelerate Delivery"
    comments              = "Control the settings related to improving the performance of delivering objects to your users."
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_origin_connectivity.json,
      data.akamai_property_rules_builder.property_rule_protocol_optimizations.json,
      data.akamai_property_rules_builder.property_rule_prefetching.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_augment_insights_rule_offload_origin" {
  rules_v2024_02_12 {
    name                  = "Offload origin"
    comments              = "Control the settings related to caching content at the edge and in the browser. As a result, fewer requests go to your origin, fewer bytes leave your data centers, and your assets are closer to your users."
    criteria_must_satisfy = "all"
    behavior {
      caching {
        behavior = "NO_STORE"
      }
    }
    behavior {
      tiered_distribution {
        enabled                 = true
        tiered_distribution_map = "CH2"
      }
    }
    behavior {
      validate_entity_tag {
        enabled = false
      }
    }
    behavior {
      remove_vary {
        enabled = false
      }
    }
    behavior {
      cache_error {
        enabled        = true
        preserve_stale = true
        ttl            = "10s"
      }
    }
    behavior {
      cache_key_query_params {
        behavior = "INCLUDE_ALL_ALPHABETIZE_ORDER"
      }
    }
    behavior {
      prefresh_cache {
        enabled     = true
        prefreshval = 90
      }
    }
    behavior {
      downstream_cache {
        allow_behavior = "LESSER"
        behavior       = "ALLOW"
        send_headers   = "CACHE_CONTROL"
        send_private   = false
      }
    }
    children = [
      data.akamai_property_rules_builder.property_rule_css_and_java_script.json,
      data.akamai_property_rules_builder.property_rule_fonts.json,
      data.akamai_property_rules_builder.property_rule_images.json,
      data.akamai_property_rules_builder.property_rule_files.json,
      data.akamai_property_rules_builder.property_rule_other_static_objects.json,
      data.akamai_property_rules_builder.property_rule_html_pages.json,
      data.akamai_property_rules_builder.property_rule_redirectlogic.json,
      data.akamai_property_rules_builder.property_rule_post_responses.json,
      data.akamai_property_rules_builder.property_rule_graph_ql.json,
      data.akamai_property_rules_builder.property_rule_uncacheable_objects.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_augment_insights_rule_strengthen_security" {
  rules_v2024_02_12 {
    name                  = "Strengthen security"
    comments              = "Control the settings that minimize the information your website shares with clients and malicious entities to reduce your exposure to threats."
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_allowed_methods.json,
      data.akamai_property_rules_builder.property_rule_obfuscate_debug_info.json,
      data.akamai_property_rules_builder.property_rule_obfuscate_backend_info.json,
      data.akamai_property_rules_builder.property_rule_hsts.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_increase_availability" {
  rules_v2024_02_12 {
    name                  = "Increase availability"
    comments              = "Control how to respond when your origin or third parties are slow or even down to minimize the negative impact on user experience."
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_simulate_failover.json,
      data.akamai_property_rules_builder.property_rule_site_failover.json,
      data.akamai_property_rules_builder.property_rule_origin_health.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_minimize_payload" {
  rules_v2024_02_12 {
    name                  = "Minimize payload"
    comments              = "Control the settings that reduce the size of the delivered content and decrease the number of bytes sent by your properties. This allows you to cut down the network overhead of your website or API."
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_compressible_objects.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_traffic_reporting" {
  rules_v2024_02_12 {
    name                  = "Traffic reporting"
    comments              = "Identify your main traffic segments so you can zoom in your traffic statistics like hits, bandwidth, offload, response codes, and errors."
    criteria_must_satisfy = "all"
    behavior {
      cp_code {
        value {
          description  = var.cpcode_name
          id           = akamai_cp_code.cp_code.id
          name         = var.cpcode_name
          products     = [var.product_id, ]
        }
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_m_pulse_rum" {
  rules_v2024_02_12 {
    name                  = "mPulse RUM"
    comments              = "Collect and analyze real-user data to monitor the performance of your website."
    criteria_must_satisfy = "all"
    behavior {
      m_pulse {
        api_key         = ""
        buffer_size     = ""
        config_override = ""
        enabled         = true
        loader_version  = "V12"
        require_pci     = false
        title_optional  = ""
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_geolocation" {
  rules_v2024_02_12 {
    name                  = "Geolocation"
    comments              = "Receive data about a user's geolocation and connection speed in a request header. If you change cached content based on the values of the X-Akamai-Edgescape request header, contact your account representative."
    criteria_must_satisfy = "all"
    criterion {
      request_type {
        match_operator = "IS"
        value          = "CLIENT_REQ"
      }
    }
    behavior {
      edge_scape {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_log_delivery" {
  rules_v2024_02_12 {
    name                  = "Log delivery"
    comments              = "Specify the level of detail you want to be logged in your Log Delivery Service reports. Log User-Agent Header to obtain detailed information in the Traffic by Browser and OS report."
    criteria_must_satisfy = "all"
    behavior {
      report {
        log_accept_language  = false
        log_cookies          = "OFF"
        log_custom_log_field = false
        log_edge_ip          = false
        log_host             = false
        log_referer          = false
        log_user_agent       = false
        log_x_forwarded_for  = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_origin_connectivity" {
  rules_v2024_02_12 {
    name                  = "Origin connectivity"
    comments              = "Optimize the connection between edge and origin."
    criteria_must_satisfy = "all"
    behavior {
      dns_async_refresh {
        enabled = true
        timeout = "1h"
      }
    }
    behavior {
      timeout {
        value = "5s"
      }
    }
    behavior {
      read_timeout {
        value = "120s"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_protocol_optimizations" {
  rules_v2024_02_12 {
    name                  = "Protocol Optimizations"
    comments              = "Serve your website using modern and fast protocols."
    criteria_must_satisfy = "all"
    behavior {
      http3 {
        enable = true
      }
    }
    behavior {
      http2 {
        enabled = ""
      }
    }
    behavior {
      allow_transfer_encoding {
        enabled = true
      }
    }
    behavior {
      sure_route {
        enable_custom_key      = false
        enabled                = true
        force_ssl_forward      = false
        race_stat_ttl          = "30m"
        sr_download_link_title = ""
        test_object_url        = "/akamai/sureroute-test-object.html"
        to_host_status         = "INCOMING_HH"
        type                   = "PERFORMANCE"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_prefetching" {
  rules_v2024_02_12 {
    name                  = "Prefetching"
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_prefetching_objects.json,
      data.akamai_property_rules_builder.property_rule_prefetchable_objects.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_prefetching_objects" {
  rules_v2024_02_12 {
    name                  = "Prefetching objects"
    comments              = "Define for which HTML pages prefetching should be enabled."
    criteria_must_satisfy = "all"
    behavior {
      prefetch {
        enabled = true
      }
    }
    children = [
      data.akamai_property_rules_builder.property_rule_bots.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_prefetchable_objects" {
  rules_v2024_02_12 {
    name                  = "Prefetchable objects"
    comments              = "Define which resources should be prefetched."
    criteria_must_satisfy = "all"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["css", "js", "jpg", "jpeg", "jp2", "png", "gif", "svg", "svgz", "webp", "eot", "woff", "woff2", "otf", "ttf", ]
      }
    }
    behavior {
      prefetchable {
        enabled = true
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_bots" {
  rules_v2024_02_12 {
    name                  = "Bots"
    comments              = "Disable prefetching for specific clients identifying themselves as bots and crawlers. This avoids requesting unnecessary resources from the origin."
    criteria_must_satisfy = "all"
    criterion {
      user_agent {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        match_wildcard       = true
        values               = ["*bot*", "*crawl*", "*spider*", ]
      }
    }
    behavior {
      prefetch {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_css_and_java_script" {
  rules_v2024_02_12 {
    name                  = "CSS and JavaScript"
    comments              = "Override the default caching behavior for CSS and JavaScript."
    criteria_must_satisfy = "any"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["css", "js", ]
      }
    }
    behavior {
      caching {
        behavior        = "MAX_AGE"
        must_revalidate = false
        ttl             = "7d"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_fonts" {
  rules_v2024_02_12 {
    name                  = "Fonts"
    comments              = "Override the default caching behavior for fonts."
    criteria_must_satisfy = "any"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["eot", "woff", "woff2", "otf", "ttf", ]
      }
    }
    behavior {
      caching {
        behavior        = "MAX_AGE"
        must_revalidate = false
        ttl             = "30d"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_images" {
  rules_v2024_02_12 {
    name                  = "Images"
    comments              = "Override the default caching behavior for images."
    criteria_must_satisfy = "any"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["jpg", "jpeg", "png", "gif", "webp", "jp2", "ico", "svg", "svgz", ]
      }
    }
    behavior {
      caching {
        behavior        = "MAX_AGE"
        must_revalidate = false
        ttl             = "30d"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_files" {
  rules_v2024_02_12 {
    name                  = "Files"
    comments              = "Override the default caching behavior for files. Files containing Personal Identified Information (PII) should require Edge authentication or not be cached at all."
    criteria_must_satisfy = "any"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["pdf", "doc", "docx", "odt", ]
      }
    }
    behavior {
      caching {
        behavior        = "MAX_AGE"
        must_revalidate = false
        ttl             = "7d"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_other_static_objects" {
  rules_v2024_02_12 {
    name                  = "Other static objects"
    comments              = "Override the default caching behavior for other static objects."
    criteria_must_satisfy = "any"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["aif", "aiff", "au", "avi", "bin", "bmp", "cab", "carb", "cct", "cdf", "class", "dcr", "dtd", "exe", "flv", "gcf", "gff", "grv", "hdml", "hqx", "ini", "mov", "mp3", "nc", "pct", "ppc", "pws", "swa", "swf", "txt", "vbs", "w32", "wav", "midi", "wbmp", "wml", "wmlc", "wmls", "wmlsc", "xsd", "zip", "pict", "tif", "tiff", "mid", "jxr", "jar", ]
      }
    }
    behavior {
      caching {
        behavior        = "MAX_AGE"
        must_revalidate = false
        ttl             = "7d"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_html_pages" {
  rules_v2024_02_12 {
    name                  = "HTML pages"
    comments              = "Override the default caching behavior for HTML pages cached on edge servers."
    criteria_must_satisfy = "all"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["html", "htm", "php", "jsp", "aspx", "EMPTY_STRING", ]
      }
    }
    behavior {
      caching {
        behavior = "NO_STORE"
      }
    }
    behavior {
      cache_key_query_params {
        behavior    = "IGNORE"
        exact_match = true
        parameters  = ["gclid", "fbclid", "utm_source", "utm_campaign", "utm_medium", "utm_content", ]
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_redirectlogic" {
  rules_v2024_02_12 {
    name                  = "Redirects"
    comments              = "Configure caching for HTTP redirects. The redirect is cached for the same TTL as a 200 response when this feature is enabled"
    criteria_must_satisfy = "all"
    behavior {
      cache_redirect {
        enabled = "false"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_post_responses" {
  rules_v2024_02_12 {
    name                  = "POST responses"
    comments              = "Define when HTTP POST requests should be cached. You should enable it under a criteria match."
    criteria_must_satisfy = "all"
    behavior {
      cache_post {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_graph_ql" {
  rules_v2024_02_12 {
    name                  = "GraphQL"
    comments              = "Define when your GraphQL queries should be cached."
    criteria_must_satisfy = "all"
    criterion {
      path {
        match_case_sensitive = false
        match_operator       = "MATCHES_ONE_OF"
        normalize            = false
        values               = ["/graphql", ]
      }
    }
    behavior {
      graphql_caching {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_uncacheable_objects" {
  rules_v2024_02_12 {
    name                  = "Uncacheable objects"
    comments              = "Configure the default client caching behavior for uncacheable content at the edge."
    criteria_must_satisfy = "all"
    criterion {
      cacheability {
        match_operator = "IS_NOT"
        value          = "CACHEABLE"
      }
    }
    behavior {
      downstream_cache {
        behavior = "BUST"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_allowed_methods" {
  rules_v2024_02_12 {
    name                  = "Allowed methods"
    comments              = "Allow the use of HTTP methods. Consider enabling additional methods under a path match for increased origin security."
    criteria_must_satisfy = "all"
    behavior {
      all_http_in_cache_hierarchy {
        enabled = true
      }
    }
    children = [
      data.akamai_property_rules_builder.property_rule_post.json,
      data.akamai_property_rules_builder.property_rule_options.json,
      data.akamai_property_rules_builder.property_rule_put.json,
      data.akamai_property_rules_builder.property_rule_delete.json,
      data.akamai_property_rules_builder.property_rule_patch.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_obfuscate_debug_info" {
  rules_v2024_02_12 {
    name                  = "Obfuscate debug info"
    comments              = "Do not expose backend information unless the request contains the Pragma debug headers"
    criteria_must_satisfy = "all"
    behavior {
      cache_tag_visible {
        behavior = "PRAGMA_HEADER"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_obfuscate_backend_info" {
  rules_v2024_02_12 {
    name                  = "Obfuscate backend info"
    comments              = "Do not expose backend information unless the request contains an additional secret header. Regularly change the conditions to use a specific unique value for the secret header."
    criteria_must_satisfy = "all"
    criterion {
      request_header {
        header_name                = "X-Akamai-Debug"
        match_case_sensitive_value = true
        match_operator             = "IS_NOT_ONE_OF"
        match_wildcard_name        = false
        match_wildcard_value       = false
        values                     = ["true", ]
      }
    }
    behavior {
      modify_outgoing_response_header {
        action                      = "DELETE"
        custom_header_name          = "X-Powered-By"
        standard_delete_header_name = "OTHER"
      }
    }
    behavior {
      modify_outgoing_response_header {
        action                      = "DELETE"
        custom_header_name          = "Server"
        standard_delete_header_name = "OTHER"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_hsts" {
  rules_v2024_02_12 {
    name                  = "HSTS"
    comments              = "Require all browsers to connect to your site using HTTPS."
    criteria_must_satisfy = "all"
    behavior {
      http_strict_transport_security {
        enable = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_post" {
  rules_v2024_02_12 {
    name                  = "POST"
    comments              = "Allow use of the POST HTTP request method."
    criteria_must_satisfy = "all"
    behavior {
      allow_post {
        allow_without_content_length = false
        enabled                      = true
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_options" {
  rules_v2024_02_12 {
    name                  = "OPTIONS"
    comments              = "Allow use of the OPTIONS HTTP request method."
    criteria_must_satisfy = "all"
    behavior {
      allow_options {
        enabled = true
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_put" {
  rules_v2024_02_12 {
    name                  = "PUT"
    comments              = "Allow use of the PUT HTTP request method."
    criteria_must_satisfy = "all"
    behavior {
      allow_put {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_delete" {
  rules_v2024_02_12 {
    name                  = "DELETE"
    comments              = "Allow use of the DELETE HTTP request method."
    criteria_must_satisfy = "all"
    behavior {
      allow_delete {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_patch" {
  rules_v2024_02_12 {
    name                  = "PATCH"
    comments              = "Allow use of the PATCH HTTP request method."
    criteria_must_satisfy = "all"
    behavior {
      allow_patch {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_simulate_failover" {
  rules_v2024_02_12 {
    name                  = "Simulate failover"
    comments              = "Simulate an origin connection problem and test the site failover configuration on the CDN staging network."
    criteria_must_satisfy = "all"
    criterion {
      content_delivery_network {
        match_operator = "IS"
        network        = "STAGING"
      }
    }
    criterion {
      request_header {
        header_name                = "breakconnection"
        match_case_sensitive_value = true
        match_operator             = "IS_ONE_OF"
        match_wildcard_name        = false
        match_wildcard_value       = false
        values                     = ["Your-Secret-Here", ]
      }
    }
    behavior {
      break_connection {
        enabled = true
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_site_failover" {
  rules_v2024_02_12 {
    name                  = "Site failover"
    comments              = "Specify how edge servers respond when the origin is not available."
    criteria_must_satisfy = "all"
    criterion {
      origin_timeout {
        match_operator = "ORIGIN_TIMED_OUT"
      }
    }
    behavior {
      fail_action {
        enabled = false
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_origin_health" {
  rules_v2024_02_12 {
    name                  = "Origin health"
    comments              = "Monitor the health of your origin by tracking unsuccessful IP connection attempts."
    criteria_must_satisfy = "all"
    behavior {
      health_detection {
        maximum_reconnects = 3
        retry_count        = 3
        retry_interval     = "10s"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_compressible_objects" {
  rules_v2024_02_12 {
    name                  = "Compressible objects"
    comments              = "Serve gzip compressed content for text-based formats."
    criteria_must_satisfy = "all"
    criterion {
      content_type {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        match_wildcard       = true
        values               = ["application/*javascript*", "application/*json*", "application/*xml*", "application/text*", "application/vnd-ms-fontobject", "application/vnd.microsoft.icon", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "font/eot*", "font/opentype", "font/otf", "image/svg+xml", "image/vnd.microsoft.icon", "image/x-icon", "text/*", "application/octet-stream*", "application/x-font-eot*", "font/ttf", "application/font-ttf", "application/font-sfnt", "application/x-tgif", ]
      }
    }
    behavior {
      gzip_response {
        behavior = "ALWAYS"
      }
    }
  }
}

data "akamai_property_rules_builder" "property_rule_redirects" {
  rules_v2024_02_12 {
    name                  = "Redirects"
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.property_rule_http_to_https_redirect.json,
    ]
  }
}

data "akamai_property_rules_builder" "property_rule_http_to_https_redirect" {
  rules_v2024_02_12 {
    name                  = "HTTP to HTTPS redirect"
    criteria_must_satisfy = "all"
    criterion {
      request_protocol {
        value = "HTTP"
      }
    }
    behavior {
      redirect {
        destination_hostname  = "SAME_AS_REQUEST"
        destination_path      = "SAME_AS_REQUEST"
        destination_protocol  = "HTTPS"
        mobile_default_choice = "DEFAULT"
        query_string          = "APPEND"
        response_code         = 301
      }
    }
  }
}
