//  权限系统

package tech.ascs.cityworks.config.auth.handler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.DefaultSavedRequest;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.util.UrlUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import tech.ascs.cityworks.config.auth.point.AgencyHeaders;
import tech.ascs.cityworks.config.property.CwOauthProperty;
import tech.ascs.cityworks.utils.HttpUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 登录验证通过后的重定向处理逻辑
 */
@Component
public class AgencyForwardAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler implements AgencyForwardHandler {

    private final CwOauthProperty property;

    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws ServletException, IOException {
        DefaultSavedRequest savedRequest = (DefaultSavedRequest) requestCache.getRequest(request, response);
        if (savedRequest == null) { // 如果是在登录页直接进行登录，则没有savedRequest，重新重定向到登录页
            if (isForwardedRequest(request)) {
                String url = build(request, property.getLoginPageUrl());
                clearAuthenticationAttributes(request);
                getRedirectStrategy().sendRedirect(request, response, url);
            } else {
                super.onAuthenticationSuccess(request, response, authentication);
            }
            return;
        }
        String targetUrlParameter = getTargetUrlParameter();
        if (isAlwaysUseDefaultTargetUrl() || (targetUrlParameter != null && StringUtils.hasText(request.getParameter(targetUrlParameter)))) {
            requestCache.removeRequest(request, response);
            super.onAuthenticationSuccess(request, response, authentication);

            return;
        }
    }

    public void onAuthenticationSuccess(final HttpServletRequest request, final HttpServletResponse response, final Authentication authentication) throws ServletException, IOException {
        DefaultSavedRequest savedRequest = (DefaultSavedRequest)requestCache.getRequest(request, response);
        if (savedRequest == null) {
            if (isForwardedRequest(request)) {
                String url = property.getDefaultRedirectUrl();
                // final String url = this.build(request, property.getLoginPageUrl());
                clearAuthenticationAttributes(request);
                getRedirectStrategy().sendRedirect(request, response, url);
            } else {
                super.onAuthenticationSuccess(request, response, authentication);
            }
            return;
        }
        String targetUrlParameter = getTargetUrlParameter();
        if (isAlwaysUseDefaultTargetUrl() || (targetUrlParameter != null && StringUtils.hasText(request.getParameter(targetUrlParameter)))) {
            requestCache.removeRequest(request, response);
            super.onAuthenticationSuccess(request, response, authentication);
            return;
        }
    }

}
