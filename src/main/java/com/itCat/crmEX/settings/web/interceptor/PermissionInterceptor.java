package com.itCat.crmEX.settings.web.interceptor;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 权限拦截器
 */
public class PermissionInterceptor implements HandlerInterceptor {

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute(Constants.SESSION_USER) == null){
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        return true;
    }
}
